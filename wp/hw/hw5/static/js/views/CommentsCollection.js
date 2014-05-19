/*global define*/

define(['app', 'marionette', 'vent', 'templates', 'views/Comment'], function (App, Marionette, vent, templates, CommentView) {
    "use strict";

    return Marionette.CollectionView.extend({
        itemView: CommentView,
        tagName: 'ul',

		initialize: function (options) {
            var self = this;
            this.timer = setInterval(function() {
                self.collection.fetch();
            }, 3000);
        }
    });
});