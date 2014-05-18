define(['marionette', 'backbone', 'templates', 'vent', 'views/Header', 'views/Body'],
       function (Marionette, Backbone, templates, vent, Header, Body) {
        "use strict";

        window.app = new Marionette.Application();

        app.options = {region: '#body'};

        app.addRegions({
            header : '#header',
            body   : '#body',
            sidebar: '#sidebar',
            main   : '#main'
        });

        app.addInitializer(function () {
        });
           
        console.log("testing from app.js");
        
        return app;
    });