/*global define*/

define(['jquery', 'marionette', 'vent', 'templates'], function ($, Marionette, vent, templates) {
    "use strict";

    return Marionette.Layout.extend({
        template : templates.addPage,
        
        tagName: 'div',

        events : {
            'click #btnAddPage' : 'addPage'
        },

        addPage: function () {
            console.log("btnAddPage");

            var page_name = document.getElementById('new_page').value;

            if (page_name) {
                $("#error").hide();
                $.ajax({
                    //async: "false",
                    type: "POST",
                    url: "/pages/" + page_name,
                    success: function (response) {
                        console.log("success POST on /assets/:assetID");
                    },
                    error: function (response) {
                        console.log("error POST on /assets/:assetID");
                    }
                });
            }
            else {
                $("#error").show();
                console.log("don't forget about the page name");
            }
        }
    });
});