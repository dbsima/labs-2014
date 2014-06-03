/*global define*/

define(['app', 'marionette', 'vent', 'templates'], function (App, Marionette, vent, templates) {
    "use strict";

    return Marionette.Layout.extend({
        template : templates.addComment,
        
        tagName: 'div',

        events : {
            'click #btnAddComment' : 'addComment'
        },

        addComment: function () {
            console.log("btnAddComment");
            var page_id = document.getElementById('page_id').innerHTML;
            var username = document.getElementById('username').value;
            var email = document.getElementById('email').value;
            var text = document.getElementById('text').value;
            var emailFilter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9])+$/;

            if (username && emailFilter.test(email) && text && text.length <= 100) { 
                $("#error").hide();
                $.ajax({
                    //async: "false",
                    type: "POST",
                    url: "/comments",
                    contentType: 'application/json;charset=UTF-8',
                    data: JSON.stringify({"page_id": page_id, "username": username, "email": email, "text": text}, null, '\t'),
                    success: function (response) {
                        console.log("success POST");
                        App.vent.trigger("updateCommentList", {"comments": "updated"});
                    },
                    error: function (response) {
                        console.log("error POST");
                    }
                });
            } else if (!emailFilter.test(email)) {
                $("#error").show();
                $("#error").text("Make sure the email is valid");
            } else if (!username) {
                $("#error").show();
                $("#error").text("Add username");
            } else {
                $("#error").show();
                $("#error").text("Make sure the the text has maximum 100 characters");
            }

            //App.vent.trigger("updateList", {"cacat": "maro"});
        }
    });
});


