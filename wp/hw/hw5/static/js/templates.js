define(function (require) {
    "use strict";

    return {
        indexHeader : require('tpl!templates/indexHeader.tmpl'),
        header      : require('tpl!templates/header.tmpl'),
        body        : require('tpl!templates/body.tmpl'),
        addPage     : require('tpl!templates/addPage.tmpl'),
        page        : require('tpl!templates/page.tmpl'),
        addComment  : require('tpl!templates/addComment.tmpl'),
        comment     : require('tpl!templates/comment.tmpl')
    };
});

