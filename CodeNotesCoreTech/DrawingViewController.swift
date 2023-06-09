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
    var lassoToolObserver: NSKeyValueObservation?
    var highlightedArea = UIView()
    let convertButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvasView()
        addHighlightArea()
        setupConvertButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupToolPicker()
    }
    
    func setupToolPicker() {
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
        
    func addHighlightArea() {
        highlightedArea = UIView(
            frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 400, height: 400))
        )
        highlightedArea.translatesAutoresizingMaskIntoConstraints = false
        highlightedArea.backgroundColor = .clear
        highlightedArea.layer.borderColor = UIColor.green.cgColor
        highlightedArea.layer.borderWidth = 2
        highlightedArea.isUserInteractionEnabled = false
        self.canvasView.addSubview(highlightedArea)
    }
        
    // Iterate through all strokes. Iterate through all the points that are in the bounding box. Color them.
    @objc func colorStrokesInHighlightedBox() {
        DispatchQueue.main.async {
            var newStrokes = [PKStroke]()
            for stroke in self.canvasView.drawing.strokes {
                var strokeToAppend = stroke
                
                for path in stroke.path {
                    var point = path.location
                    if CGRectContainsPoint(self.highlightedArea.frame, point) {
                        strokeToAppend.ink.color = .systemPink
                        break
                    }
                }
                newStrokes.append(strokeToAppend)
            }
            self.canvasView.drawing.strokes = newStrokes
        }
    }    
    
    func setupConvertButton() {
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        convertButton.backgroundColor = .green
        convertButton.setTitle("Convert", for: .normal)
        convertButton.frame = CGRect(origin: CGPoint(x: 600, y: 600), size: CGSize(width: 100, height: 100))
        self.canvasView.addSubview(convertButton)
        convertButton.addTarget(self, action: #selector(colorStrokesInHighlightedBox), for: .touchDown)
    }

    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print("=== canvasViewDrawingDidChange\n")
    }
    
    func canvasViewDidFinishRendering(_ canvasView: PKCanvasView) {
        print("=== canvasViewDidFinishRendering")
    }
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        print("=== canvasViewDidBeginUsingTool: ", canvasView.tool)
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        print("=== canvasViewDidEndUsingTool")
    }
}
