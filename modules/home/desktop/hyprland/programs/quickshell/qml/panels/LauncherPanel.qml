import QtQuick
import Quickshell as QS
import Quickshell.Hyprland as QSH

import "./components"
import "./components/launcher"
import "../singletons"

PickerPanel {
    id: root

    pickerOpened: Launcher.opened && QSH.Hyprland.monitorFor(topBar.screen) === QSH.Hyprland.focusedMonitor
    placeholderText: "Rechercher une application..."

    model: QS.ScriptModel {
        id: _appModel
        values: QS.DesktopEntries.applications.values.filter(root._matchesSearch).sort((a, b) => {
            if (Launcher.searchText === "")
                return a.name.localeCompare(b.name);
            return root._appScore(b) - root._appScore(a);
        })
    }

    delegate: Component {
        AppItem {}
    }

    onCloseRequested: Launcher.close()
    onSearchUpdated: text => Launcher.searchText = text
    onItemActivated: data => {
        data.execute();
        Launcher.close();
    }

    // Returns a fuzzy match score for `str` against `query`.
    // Characters of query must appear in order (subsequence).
    // Higher score = better match. Returns -1 if no match.
    function _fuzzyScore(str: string, query: string): int {
        const s = str.toLowerCase();
        const q = query.toLowerCase();

        let si = 0, qi = 0, score = 0, consecutive = 0;

        while (si < s.length && qi < q.length) {
            if (s[si] === q[qi]) {
                // Bonus: start of string
                if (si === 0)
                    score += 10;
                else
                // Bonus: word boundary (preceded by separator)
                if (" -_.".includes(s[si - 1]))
                    score += 8;
                // Bonus: consecutive chars
                score += consecutive * 4;
                consecutive++;
                qi++;
            } else {
                consecutive = 0;
            }
            si++;
        }

        if (qi < q.length)
            return -1;

        // Prefer shorter strings (less noise)
        score -= Math.floor(s.length / 4);

        return score;
    }

    // Best fuzzy score across name, genericName and keywords.
    function _appScore(app: QS.DesktopEntry): int {
        const q = Launcher.searchText;
        let best = _fuzzyScore(app.name, q);

        if (app.genericName !== "")
            best = Math.max(best, _fuzzyScore(app.genericName, q));

        for (const k of app.keywords)
            best = Math.max(best, _fuzzyScore(k, q));

        return best;
    }

    function _matchesSearch(app: QS.DesktopEntry): bool {
        if (Launcher.searchText === "")
            return true;

        return _appScore(app) >= 0;
    }
}
