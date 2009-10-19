(function() {

// delicious, hatebu, livedoorclip, googlebookmarks
let sbm_name = liberator.globalVariables.sbmincsearch_service_name || "delicious";
let sbm_service = sbm_name + "_incsearch";

// max
let max = liberator.globalVariables.sbmincsearch_max || 15;

// load scripts
let module = {};
try {
    liberator.loadScript("chrome://" + sbm_service + "/content/database.js", module);
    liberator.loadScript("chrome://" + sbm_service + "/content/incsearch.js", module);
}
catch(e)
{
    liberator.echoerr(e);
    return;
}

// load database
let database = new module.Database('bookmark', sbm_service);

// only use search method
module.IncSearch.prototype.checkLoop = module.IncSearch.prototype.reset = function() {};
let incsearch = new module.IncSearch(null, null, { dispMax: max, database: database });

// completion
let format = {
    anchored: false,
    keys: { text: 'url', description: 'title', icon: '', extra: 'extra' },
    title: [sbm_name, "Info"],
    process: [
        // Title
        function(item, text) {
            let url = item.text.replace(/^https?:\/\//, '');
            return <>{item.description} <span class="extra-info">{url}</span></>;
        },
        // Info
        function(item, text) {
            return <><span class="extra-info">{item.extra}</span></>;
        }
    ]
};

// create extra
let result_mapper = function(item) {
    item.extra = [item.tags.replace(/\s/g, ""), item.info].join(" ");
    return item;
};

// completer
let completer = function(context, args) {
    context.format = format;
    context.filters = [];

    incsearch.search(context.filter.split(/\s/), 0);
    context.completions = incsearch.results.map(result_mapper);
};

// add commmand
commands.addUserCommand([sbm_name + "Incsearch"], sbm_name + " IncSearch",
    function(args) {
        liberator.open(args.string, args.bang ? liberator.NEW_TAB : null);
    },
    {
        completer: completer,
        literal: 0,
        argCount: '*',
        bang: true
    },
    true);

// add complete option
completion.addUrlCompleter("I", sbm_name + " IncSearch", completer);

})();
