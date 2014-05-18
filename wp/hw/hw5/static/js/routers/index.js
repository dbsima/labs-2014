define(['marionette'], function (Marionette) {
    'use strict';

    return Marionette.AppRouter.extend({
        
        appRoutes: {
            ''              : 'index',
            //'edit'          : 'editFile',
            'render/*path'    : 'showPage'
        }
    });
});
