// http://github.com/voidy21/dotfiles/raw/master/.vimperator/plugin/opener.js


liberator.registerObserver(
  "enter",
  function () {
    let U = liberator.plugins.libly.$U;
    //BarTabs用
    let mTabs = document.getElementById("content").mTabs;

    function jump (url) {
      let index = 0;
      let url = util.stringToURLArray(url).toString();
      for each ( [,tab] in tabs.browsers ) {
        if(url == tab.currentURI.spec ||
           url == mTabs[index].linkedBrowser.userTypedValue){
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
          }
        );
      }
    );

    //buffer.followLink()を変更
    //hint-a-hint時[f,F]に対象のタブが既に開いてあったらjump
    let (ignore = false) {
      let ignoreBlock = function (block) {
        ignore = true;
        let result = block();
        ignore = false;
        return result;
      };

      U.around(
        buffer,
        "followLink",
        function (next, args) {
          return ignoreBlock(function () {
            let [elem,] = args;
            let url = elem.href;
            if (!(url && jump(url))){
              liberator.echo("Now Loading... " + url);
              return next();
            }
          });
        }
      );

      document.addEventListener(
        'click',
        function (event) {
          if (ignore)
            return;
          let e = event.target;
          if (e && e.tagName.match(/^a$/i) && e.href && jump(e.href)) {
            event.preventDefault();
            event.stopPropagation();
          }
        },
        true
      );
    }

  }
);
