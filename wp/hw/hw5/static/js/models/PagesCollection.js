define(["jquery", "backbone", "models/Page"],
       function ($, Backbone, PageModel) {
        "use strict";
        return Backbone.Collection.extend({
            model: PageModel,
            url: '/pages'
        });
    });