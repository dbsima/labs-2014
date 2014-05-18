/*global define*/

define(['marionette', 'vent', 'templates'], function (Marionette, vent, templates) {
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
            //form_data.append("page_name", page_name);
            console.log(page_name);
            $.ajax({
                async: "false",
                type: "POST",
                url: "/pages/" + page_name,
                //contentType: 'application/json;charset=UTF-8',
                //data: JSON.stringify({"composed_image": dataUrl}, null, '\t'),
                success: function (response) {
                    console.log("success POST on /assets/:assetID");
                    console.log(response);
                    
                },
                error: function (response) {
                    console.log("error POST on /assets/:assetID");
                    console.log(response);
                }
            });
            // Remove model from collection 
            // (TODO: it's a hack; if the model has more than one collection it wont work)
            this.model.collection.add(this.model);
        }
    });
});