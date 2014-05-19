/*global define*/

define(['jquery', 'marionette', 'backbone', 'vent', 'templates'], function ($, Marionette, Backbone, vent, templates) {
    "use strict";

    return Marionette.ItemView.extend({
        template : templates.page,
        tagName: 'li',

        events : {
            'click #btnDeletePage' : 'deletePage'
        },

        deletePage: function () {
            console.log("btnDeletePage");
            
            var page_id = document.getElementById('btnDeletePage').getAttribute('data-id');

            $.ajax({
                async: "false",
                type: "DELETE",
                url: "/pages/" + page_id,
                success: function (response) {
                    console.log("success POST on /assets/:assetID");
                },
                error: function (response) {
                    console.log("error POST on /assets/:assetID");
                }
            });

            // Remove model from collection 
            // (TODO: it's a hack; if the model has more than one collection it wont work)
            this.model.collection.remove(this.model);
		}
    });
});