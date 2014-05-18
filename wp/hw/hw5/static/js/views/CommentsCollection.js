/*global define*/

define(['marionette', 'vent', 'templates', 'views/Comment'], function (Marionette, vent, templates, CommentView) {
    "use strict";

    return Marionette.CollectionView.extend({
        itemView: CommentView,
        tagName: 'ul'
    });
});