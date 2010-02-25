// via http://vimperator.g.hatena.ne.jp/nokturnalmortum/20100120/1263927707


(function () {
    let U = liberator.plugins.libly.$U;

    function jump (url) {
        let index = 0;
        let url = util.stringToURLArray(url).toString();
        for each ( [,tab] in tabs.browsers ) {
            if(url == tab.currentURI.spec){
                tabs.select(index);
                return true;
            }
            ++index;
        }
        return false;
    }

    "open tabopen edit".split(/\s/).forEach(
        function (name) {
        let command = commands.get(name);
        if (!command)
            return;
        U.around(
            command,
            "action",
            function (next, args) {
                let url = args[0].string;
                if (!(url && jump(url)))
                    return next();
            },
            true
        );
    }
    );

    //buffer.followLink()を変更
    //hint-a-hint時[f,F]に対象のタブが既に開いてあったらjump
    U.around(
        buffer,
        "followLink",
        function (next, args) {
            let [elem,] = args;
            let url = elem.href;
            if (!(url && jump(url))){
                liberator.echo("Now Loading...  " + url);
                return next();
            }
        },
        true
    );
})();

