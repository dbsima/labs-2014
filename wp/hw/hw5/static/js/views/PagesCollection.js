/*global define*/

define(['marionette', 'vent', 'templates', 'views/Page'], function (Marionette, vent, templates, PageView) {
    "use strict";

    return Marionette.CollectionView.extend({
        itemView: PageView,
        tagName: 'ul',
        initialize : function(){
          var self = this;
          this.timer = setInterval(function() {
            self.collection.fetch();
          }, 3000);
		    }
    });
});