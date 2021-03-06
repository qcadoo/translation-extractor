Ext.onReady(function() {
    Ext.create('ads.store.StageTypes',{
        data : [
            { "name": "Guideline", "value": "guideline" },
            { "name": "Project", "value": "project" }
        ]
    });

    ads.app.getController('Main').errorTitle = 'Error';
});

Ext.define("ads.locale.en.view.project.List", {
    override: "ads.view.project.List",
    dateFormat: 'd-m-Y',
    daysText : ' days',
    removeErrorTitle: "Remove error!",
    hasStagesErrorMsg : "Can\'t remove project with any stage.",
    hasQuote: "Intentionally contains \" character",

    initComponent: function () {
        this.callParent();

        this.setTitle('Projects');
        this.lookupReference('newButton').setText('New');
        this.lookupReference('editButton').setText('Edit');
        this.lookupReference('tooltippedButton').tooltip = 'Button tooltip';

        this.queryById('clientNameColumn').setText('Client');
        this.queryById('nameColumn').setText('Name');
        this.findPlugin('rowexpander').rowBodyTpl.set(
            '<p><b>ACCEPTANCE</b></p>' +
            '<p><b> - Substantive:</b></p>' +
            '<p><b> -- KP Arton:</b> {id * 5}%</p>' +
            '<p><b> -- SP Arton:</b> {id * 4}%</p>' +
            '<p><b> -- KP Client:</b> {id * 3}%</p>' +
            '<br/>' +
            '<p><b> - Financial:</b></p>' +
            '<p><b> -- SP Arton:</b> {id * 4}%</p>' +
            '<p><b> -- KP Client:</b> {id * 3}%</p>'
        );
    }
});
