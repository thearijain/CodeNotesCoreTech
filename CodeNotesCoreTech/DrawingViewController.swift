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
        findDrawingsInBox()
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
        
    // Iterate through all strokes. Find strokes that are in the bounding box. Color them.
    @objc func colorStrokesInHighlightedBox() {
        DispatchQueue.main.async {
            var newStrokes = [PKStroke]()
            for stroke in self.canvasView.drawing.strokes {
                let boundingBox = self.getStrokeBoundingBox(stroke: stroke)
                if CGRectIntersectsRect(self.highlightedArea.bounds, boundingBox) {
                    // Color this stroke
                    var coloredStroke = PKStroke(ink: stroke.ink, path: stroke.path)
                    coloredStroke.ink.color = .red
                    newStrokes.append(coloredStroke)
                } else {
                    newStrokes.append(stroke)
                }
            }
            self.canvasView.drawing.strokes = newStrokes
        }
    }
    
    func getStrokeBoundingBox(stroke: PKStroke) -> CGRect {
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxX = CGFloat.leastNormalMagnitude
        var maxY = CGFloat.leastNormalMagnitude
        for path in stroke.path {
            let point = path.location
            minX = min(minX, point.x)
            minY = min(minY, point.y)
            maxX = max(maxX, point.x)
            maxY = max(maxY, point.y)
        }
        let strokeBoundingBox = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        return strokeBoundingBox
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
