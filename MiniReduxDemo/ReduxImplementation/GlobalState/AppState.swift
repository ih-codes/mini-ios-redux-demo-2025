// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

struct AppState: StateType, Sendable {
    let activeScreens: ActiveScreensState

    static let reducer: Reducer<Self> = { state, action in
        return AppState(activeScreens: ActiveScreensState.reducer(state.activeScreens, action))
    }

    func screenState<S: ScreenState>(_ s: S.Type,
                                     for screen: AppScreen,
                                     window: WindowUUID?) -> S? {
        return activeScreens.screens
            .compactMap {
                switch ($0, screen) {
                case (.searchEngines(let state), .searchEngines): return state as? S
                default: return nil
                }
            }.first(where: {
                // Most screens should be filtered based on the specific identifying UUID.
                // This is necessary to allow us to have more than 1 of the same type of
                // screen in Redux at the same time. If no UUID is provided we return `first`.
                guard let expectedUUID = window else { return true }
                // Generally this should be considered a code smell, attempting to select the
                // screen for an .unavailable window is nonsensical and may indicate a bug.
                guard expectedUUID != .unavailable else { return true }

                return $0.windowUUID == expectedUUID
            })
    }

    static func defaultState(from state: AppState) -> AppState {
        return AppState(activeScreens: state.activeScreens)
    }
}

extension AppState {
    init() {
        activeScreens = ActiveScreensState()
    }
}

@MainActor
let middlewares: [Middleware<AppState>] = [
    SearchEnginesMiddleware().searchEnginesProvider,
]

// In order for us to mock and test the middlewares easier,
// we change the store to be instantiated as a variable.
// For non testing builds, we leave the store as a constant.
#if TESTING
@MainActor
var store: any DefaultDispatchStore<AppState> = Store(
    state: AppState(),
    reducer: AppState.reducer,
    middlewares: AppConstants.isRunningUnitTest ? [] : middlewares
)
#else
@MainActor
let store: any DefaultDispatchStore<AppState> = Store(state: AppState(),
                                                      reducer: AppState.reducer,
                                                      middlewares: middlewares)
#endif
