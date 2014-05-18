define(["jquery", "backbone", "models/Comment"],
       function ($, Backbone, CommentModel) {
        "use strict";
        return Backbone.Collection.extend({
            model: CommentModel,

            initialize: function (options) {
                console.log(options);
                this.path = options.path;
            },
            url: function() {
            	return '/comments/' + this.path;
            }
        });
    });