define(['marionette', 'vent', 'templates', 'views/AddPage', 'views/PagesCollection'],
       function (Marionette, vent, templates, AddPageView, PagesCollectionView) {
        "use strict";

        return Marionette.Layout.extend({

            template : templates.body,

            tagName: 'div',

            className: 'row-fluid',

            regions : {
                add_to_list : '#add_to_list',
                list : '#list'
            },

            initialize : function (options) {
                this.options = options;
                console.log("here in body I have ");
                console.log(this.options);
            },

            onRender : function () {
                this.add_to_list.show(this.options.add_to_list);
                this.list.show(this.options.list);
            }
        });
    });
