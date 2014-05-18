/*global define*/

define(['marionette', 'vent', 'templates', 'views/Page'], function (Marionette, vent, templates, PageView) {
    "use strict";

    return Marionette.CollectionView.extend({
        itemView: PageView,
        tagName: 'ul'
    });
});