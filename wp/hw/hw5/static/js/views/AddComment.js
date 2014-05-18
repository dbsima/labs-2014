/*global define*/

define(['marionette', 'vent', 'templates'], function (Marionette, vent, templates) {
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
            //form_data.append("page_name", page_name);
            console.log(page_id);
            
            $.ajax({
                async: "false",
                type: "POST",
                url: "/comments",
                contentType: 'application/json;charset=UTF-8',
                data: JSON.stringify({"page_id": page_id, "username": username, "email": email, "text": text}, null, '\t'),
                success: function (response) {
                    console.log("success POST");
                    console.log(response);
                    
                },
                error: function (response) {
                    console.log("error POST");
                    console.log(response);
                }
            });
            // Remove model from collection 
            // (TODO: it's a hack; if the model has more than one collection it wont work)
            //this.model.collection.add(this.model);
        }
    });
});


