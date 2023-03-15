//
//  DrawingViewController.swift
//  CodeNotesCoreTech
//
//  Created by Ari Jain on 3/15/23.
//

import Foundation
import UIKit
import PencilKit

class DrawingViewController: UIViewController, PKCanvasViewDelegate, PKToolPickerObserver {
    
    var canvasView = PKCanvasView()
    var toolPicker = PKToolPicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvasView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        view.addSubview(canvasView)
    }
    
    func setupCanvasView() {
        canvasView = PKCanvasView(frame: self.view.bounds)
        canvasView.delegate = self
        view.addSubview(canvasView)
        canvasView.frame = view.bounds
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print("=== canvasViewDrawingDidChange")
    }
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        print("=== canvasViewDidFinishRendering")
    }
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        print("=== canvasViewDidBeginUsingTool")
    }
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        print("=== canvasViewDidEndUsingTool")
    }
    
}
