//
//  UndoRedoObserver.swift
//  OHWR Datapal
//
//  Created by David Bielik on 10/03/2023.
//

import SwiftUI

class UndoRedoObserver: ObservableObject {
    var undoManager: UndoManager? { didSet { updateUndoRedo() } }
    
    @Published var canUndo = false
    @Published var canRedo = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRedoChange), name: .NSUndoManagerDidRedoChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .NSUndoManagerDidRedoChange, object: nil)
    }
    
    @objc
    private func didRedoChange() {
        canRedo = undoManager?.canRedo ?? false
    }
    
    // MARK: - Public
    
    public func updateUndoRedo() {
        if let undoManager = self.undoManager {
            canUndo = undoManager.canUndo
            canRedo = undoManager.canRedo
        }
    }
}
