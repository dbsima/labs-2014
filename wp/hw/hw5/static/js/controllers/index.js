define(['app',
        'backbone',
        'vent',
        'views/IndexHeader',
        'models/PagesCollection',
        'views/PagesCollection',
        'views/Body',
        'views/Header',
        'views/AddPage',
        'models/Page',
        'models/CommentsCollection',
        'views/CommentsCollection',
        'models/Comment',
        'views/AddComment'
       ],
       function (app,
                  Backbone,
                  vent,
                  IndexHeaderView,
                  PagesCollectionModel,
                  PagesCollectionView,
                  BodyView,
                  HeaderView,
                  AddPageView,
                  PageModel,
                  CommentsCollectionModel,
                  CommentsCollectionView,
                  CommentModel,
                  AddCommentView
                 ) {
        "use strict";

        return {
            initialize: function (options) {
                this.options = options;
                //this.user_model = new UserModel();
            },
            
            index: function () {
                app.header.show(new IndexHeaderView(app.options));
                this.collection = new PagesCollectionModel();
                var self = this;
                this.collection.fetch({
                    success: function (pages) {
                        var pages_view = new PagesCollectionView({ collection: self.collection });
                        app.body.show(new BodyView({
                            add_to_list: new AddPageView(),
                            list: pages_view
                        }));
                    }
                });
            },
            showPage: function (path) {
                console.log("showPage " + path);
                this.collection = new CommentsCollectionModel({"path": path});
                var self = this;
                this.collection.fetch({
                    success: function (pages) {
                        var comments_view = new CommentsCollectionView({ collection: self.collection });
                        app.body.show(new BodyView({
                            add_to_list: new AddCommentView(),
                            list: comments_view
                        }));
                    }
                });
            }
        };
    });
