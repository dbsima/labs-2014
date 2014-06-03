"""
This module represents a cluster's computational node.

Computer Systems Architecture course
Assignment 1 - Cluster Activity Simulation
march 2013
"""

import threading

class Node:
	"""
	Class that represents a cluster node with computation and storage
	functionalities.
	"""

	def __init__(self, node_ID, block_size, matrix_size, data_store):
		"""
		Constructor.

		@param node_ID: a pair of IDs uniquely identifying the node;
		IDs are integers between 0 and matrix_size/block_size
		@param block_size: the size of the matrix blocks stored in this node's
		datastore
		@param matrix_size: the size of the matrix
		@param data_store: reference to the node's local data store
		"""
		self.node_ID = node_ID
		self.block_size = block_size
		self.matrix_size = matrix_size
		self.data_store = data_store

		# list of the tasks
		self.tasks = []

		self.dict = {}

		# create the thread
		self.thread = MyThread(self, block_size)

		#start the thread
		self.thread.start()

	def set_nodes(self, nodes):
		"""
		Informs the current node of the other nodes in the cluster.
		Guaranteed to be called before the first call to compute_matrix_block.
		@param nodes: a list containing all the nodes in the cluster
		"""

		# introduce the nodes from the cluster in a dictionary where the key is
		# the position of a node in the matrix and the value is the node itself
		for index in xrange(len(nodes)):
			i = nodes[index].node_ID[0]
			j = nodes[index].node_ID[1]
			self.dict[(i, j)] = nodes[index]

	def compute_matrix_block(self, start_row, start_col, num_rows, num_cols):
		"""
		Computes a given block of the result matrix.
		The method invoked by FEP nodes.

		@param start_row: the index of the first row in the block
		@param start_column: the index of the first column in the block
		@param num_rows: number of rows in the block
		@param num_columns: number of columns in the block
		@return: the block of the result matrix encoded as a row-order list of 
		lists of integers
		"""

		compute_matrix = ComputeMatrix(self, start_row, start_col, num_rows, num_cols, self.block_size, self.matrix_size, self.dict)
		compute_matrix.compute()

		return compute_matrix.result

	def shutdown(self):
		"""
		Instructs the node to shutdown (terminate all threads).
		"""
		# the thread has stoped running
		self.thread.stop = True

		# wait to finish execution
		self.thread.join()

class NodeResponse:
	"""
	Class that represents the result of a node after a query
	"""

	def __init__(self, row, col, elem, type):
		"""
		Constructor.

		@param row: the row index of the element
		@param col: the col index of the element
		@param elem: the current element
		@param type: the type of the matrix
		"""
		self.row  = row
		self.col  = col
		self.elem = elem
		self.type = type

class Task:
	"""
	Class that that represents a certain task
	"""

	def __init__(self, calling_node, row, col, type):
		"""
		Constructor.
		
		@param calling_node: the node that has given the task and expects
		the answer back
		@param row: the row position of the element inside the matrix
		@param col: the column position of the element inside the matrix
		@param type: the type of the matrix
		type 'a' is for matrix A and type 'b' is for matrix B
		"""

		self.calling_node = calling_node
		self.row = row
		self.col = col
		self.type = type

class ComputeMatrix():
	"""
	Class used for computing a matrix multiplication task
	"""
	def __init__(self, node, start_row, start_col, num_rows, num_cols, block_size, matrix_size, dict):
		"""
		Constructor.

		@param node: the current node
		@param start_row: the index of the first row in the block
		@param start_column: the index of the first column in the block
		@param num_rows: number of rows in the block
		@param num_columns: number of columns in the block
		@param block_size: the size of the matrix blocks stored in this node's
		datastore
		@param matrix_size: the size of the matrix
		@param dict: the nodes stored in a dictionary
		"""

		self.node = node
		self.dict = dict
		self.start_row = start_row
		self.start_col = start_col
		self.num_rows = num_rows
		self.num_cols = num_cols
		self.matrix_size = matrix_size
		self.block_size = block_size

		# used to store the task queries given to the nodes
		self.queries_to_nodes = []

		#used to store the responses from the queried node
		self.responses_from_nodes = []

		# create lock
		self.lock = threading.Lock()

		#result: the required block from the matrix multiplication
		self.result = [[0 for i in xrange(self.num_cols)]for j in xrange(self.num_rows)]

		#rows required for matrix multiplication from the first matrix
		self.A = [[0 for i in xrange(self.matrix_size)]for j in xrange(self.matrix_size)]

		#columns required for matrix multiplication from the second matrix
		self.B = [[0 for i in xrange(self.matrix_size)]for j in xrange(self.matrix_size)]

	def receive_response(self, response):
		"""
		stores a response from a node
		"""
		# entering critical section
		self.lock.acquire()

		self.responses_from_nodes.append(response)

		# exiting critical section
		self.lock.release()

	def compute(self):
		"""
		computes the block multiplication
		"""
		#counts the queried tasks
		num_tasks = 0

		#asks other nodes for the elements stored in their datastores for matrixA
		#for an element m[i][j] only ask for the rows i from A
		for row in xrange(self.num_rows):
			for col in xrange(self.matrix_size):
				#computes the node ID
				i = (row + self.start_row)/self.block_size
				j = (col)/self.block_size
				task = Task(self, row + self.start_row, col,'a')
				self.queries_to_nodes.append(task)
				self.dict[(i, j)].thread.receive_task(task)
				num_tasks += 1

		#asks other nodes for the elements stored in their datastores for matrixB
		#for an element m[i][j] only ask for the columns j from B
		for row in xrange(self.matrix_size):
			for col in xrange(self.num_cols):
				#computes the node ID
				i = (row)/self.block_size
				j = (col + self.start_col)/self.block_size
				task = Task(self, row, col + self.start_col, 'b')
				self.queries_to_nodes.append(task)
				self.dict[(i, j)].thread.receive_task(task)
				num_tasks += 1

		#waits until the number of queried tasks equals to the responses received
		while len(self.responses_from_nodes) != len(self.queries_to_nodes):
			pass

		#builds the blocks needed for the multiplication
		for ind in xrange(num_tasks):
			row = self.responses_from_nodes[ind].row
			col = self.responses_from_nodes[ind].col
			if(self.responses_from_nodes[ind].type == 'a'):
				self.A[row][col] = self.responses_from_nodes[ind].elem
			else:
				self.B[row][col] = self.responses_from_nodes[ind].elem

		#multiply the 2 blocks
		for row in xrange(self.num_rows):
			for col in xrange(self.num_cols):
				for k in xrange(0, self.matrix_size, 1):
					self.result[row][col] += self.A[row + self.start_row][k] * self.B[k][col + self.start_col]


class MyThread(threading.Thread):
	"""
	Class that represents a thread used for inter-node communication
	"""
	def __init__(self, node, block_size):
		"""
		Constructor.

		@param node: the node that owns the thread
		@param block_size: the block size of the datastore
		"""
		threading.Thread.__init__(self)
		self.node = node
		self.block_size = block_size

		# the thread is running
		self.stop = False

		# task counter
		self.count = 0
		
		#create lock
		self.lock = threading.Lock()

		#stores the given tasks; a list of Tasks objects
		self.data_tasks = []

	def receive_task(self, task):
		"""
		Inserts a new task
		"""
		# entering critical section
		self.lock.acquire()

		# a new task has beed received
		self.data_tasks.append(task)
		self.count += 1

		# exiting critical section
		self.lock.release()

	def run(self):
		"""
		Method that represents the action of a thread
		"""
		# registers the thread into the datastore
		self.node.data_store.register_thread(self.node)

		# a thread can run while it hasn't beed shut down
		while self.stop == False:
			# entering critical section
			self.lock.acquire()
			#extract a new task
			if len(self.data_tasks) > 0:
				task = self.data_tasks.pop()
				i = task.row
				j = task.col

				#get the element
				if task.type == 'a':
					elem = self.node.data_store.get_element_from_a(self.node, i % self.block_size, j % self.block_size)
				if task.type == 'b':
					elem = self.node.data_store.get_element_from_b(self.node, i % self.block_size, j % self.block_size)

				#sends the response to the node that has given the task
				node_response = NodeResponse(i, j, elem, task.type)
				task.calling_node.receive_response(node_response)

			# exiting critical section
			self.lock.release()

