/*global define*/

define(['app', 'jquery', 'marionette', 'backbone', 'vent', 'templates'], function (App, $, Marionette, Backbone, vent, templates) {
    "use strict";

    return Marionette.ItemView.extend({
        template : templates.comment,
        tagName: 'li',

        deletePage: function () {
            console.log("btnDeletePage");
            
            var page_id = document.getElementById('btnDeletePage').getAttribute('data-id')
            console.log(page_id);
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
		}
    });
});