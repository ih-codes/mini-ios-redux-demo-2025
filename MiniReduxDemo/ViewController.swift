//
//  ViewController.swift
//  MiniReduxDemo
//

import UIKit

class ViewController: UIViewController,
                      StoreSubscriber {
    // Stub
    private let windowUUID: WindowUUID = UUID()

    @IBOutlet weak var searchEngineLabel: UILabel!
    @IBOutlet weak var loadEnginesActionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeToRedux()
    }

    // MARK: -- unsubscribeFromRedux
    deinit {
        // TODO: FXIOS-13097 This is a work around until we can leverage isolated deinits
        guard Thread.isMainThread else {
            assertionFailure("ViewController was not deallocated on the main thread. Redux was not removed")
            return
        }

        MainActor.assumeIsolated {
            unsubscribeFromRedux()
        }
    }

    // IHC - Is there a better way we can do this? What do we use closeScreen for?
    // IHC - State updates didAppear/didDisappear symmetric updates to cause newState to fire... (in case background activities
    // changed the state behind the scenes while unsubscribed?)
    func unsubscribeFromRedux() {
        let action = ScreenAction(windowUUID: windowUUID,
                                  actionType: ScreenActionType.closeScreen,
                                  screen: .searchEngines)
        store.dispatch(action)
    }

    // MARK: -- subscribeToRedux

    func subscribeToRedux() {
        // Sent showScreen
        // IHC  -- should this be separated?
        let screenAction = ScreenAction(windowUUID: windowUUID,
                                        actionType: ScreenActionType.showScreen,
                                        screen: .searchEngines)
        store.dispatch(screenAction)

        // Subscribe to Redux
        let uuid = windowUUID
        store.subscribe(self, transform: {
            return $0.select({ appState in
                return SearchEnginesState(appState: appState, uuid: uuid)
            })
        })
    }

    func newState(state: SearchEnginesState) {
        prettyPrint(withPrefix: "newState", state)

        switch state.searchEnginesLoadingState {
        case .notStarted:
            searchEngineLabel.text = "Waiting..."
        case .loading:
            searchEngineLabel.text = "Loading..."
        case .succeeded(let engines):
            searchEngineLabel.text = "Success! Engines:\n\(engines.map(\.name))"
        case .failed(let error):
            searchEngineLabel.text = "Failed! Error: \(error)"
        }
    }

    // MARK: -- User Interface

    @IBAction func didTapLoadEnginesActionButton(_ sender: Any) {
        /// IHC - Example. Without constraints on which `ActionType`s can be associated with which `Action`s, we can fire a
        /// `ScreenAction` with a `SearchEnginesActionType`, which doesn't make much sense! (see below)
        let action = ScreenAction(windowUUID: windowUUID,
                                  actionType: SearchEnginesActionType.didTapLoadEnginesButton,
                                  screen: .searchEngines)
        store.dispatch(action)
    }
}
