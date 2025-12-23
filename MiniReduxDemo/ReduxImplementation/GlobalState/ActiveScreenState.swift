// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

enum AppScreenState: Sendable, Equatable {
    case searchEngines(SearchEnginesState)

    static let reducer: Reducer<Self> = { state, action in
        switch state {
        case .searchEngines(let state):
            return .searchEngines(SearchEnginesState.reducer(state, action))
        }
    }

    /// Returns the matching AppScreen enum for a given AppScreenState
    var associatedAppScreen: AppScreen {
        switch self {
        case .searchEngines: return .searchEngines
        }
    }

    var windowUUID: WindowUUID? {
        switch self {
        case .searchEngines(let state): return state.windowUUID
        }
    }
}

struct ActiveScreensState: Sendable, Equatable {
    let screens: [AppScreenState]

    init() {
        self.screens = []
    }

    init(screens: [AppScreenState]) {
        self.screens = screens
    }

    static let reducer: Reducer<Self> = { state, action in
        // Add or remove screens from the active screen list as needed
        var screens = updateActiveScreens(action: action, screens: state.screens)

        // Reduce each screen state
        screens = screens.map { AppScreenState.reducer($0, action) }

        return ActiveScreensState(screens: screens)
    }

    private static func updateActiveScreens(action: Action, screens: [AppScreenState]) -> [AppScreenState] {
        guard let action = action as? ScreenAction else { return screens }

        var screens = screens

        switch action.actionType {
        case ScreenActionType.closeScreen:
            screens = screens.filter({
                return $0.associatedAppScreen != action.screen || $0.windowUUID != action.windowUUID
            })
        case ScreenActionType.showScreen:
            let uuid = action.windowUUID
            switch action.screen {
            case .searchEngines:
                screens.append(.searchEngines(SearchEnginesState(windowUUID: uuid)))
            }
        default:
            return screens
        }

        return screens
    }
}
