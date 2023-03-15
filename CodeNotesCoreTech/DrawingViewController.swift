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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCanvasView()
        findDrawingsInBox()
        addHighlightArea()
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
    
    func watchLassoTool() {
//        let observer = lassoTool.observe(\.selectedBezierPath) { tool, change in
//
//            // Retrieve the selected path (if any)
//            if let selectedPath = tool.selectedBezierPath {
//
//                // Create a new PKDrawing object containing only the selected region
//                let selectedDrawing = PKDrawing(
//                    strokes: canvasView.drawing.strokes.filter { selectedPath.intersects($0.path) },
//                    backgroundColor: canvasView.drawing.backgroundColor
//                )
//
//                // Do something with the selectedDrawing, e.g. save it to a file or display it in a new view.
//
//                // Reset the selected path
//                tool.selectedBezierPath = nil
//            }
//        }
//        self.lassoToolObserver = observer
    }
    
    func addHighlightArea() {
        highlightedArea = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 400, height: 400)))
        highlightedArea.translatesAutoresizingMaskIntoConstraints = false
        highlightedArea.backgroundColor = .clear
        highlightedArea.layer.borderColor = UIColor.green.cgColor
        highlightedArea.layer.borderWidth = 2
        highlightedArea.isUserInteractionEnabled = false
        self.canvasView.addSubview(highlightedArea)
    }
    
    func findDrawingsInBox() {
        var boundingBoxes: [CGRect] = []
        for stroke in self.canvasView.drawing.strokes {
            let boundingBox = getStrokeBoundingBox(stroke: stroke)
            boundingBoxes.append(boundingBox)
        }
        
        for box in boundingBoxes {
            if CGRectIntersectsRect(highlightedArea.bounds, box) {
                print("=== overlapping box")
            }
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
    
    func changeColor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("=== begin")
            var newStrokes = [PKStroke]()
            for stroke in self.canvasView.drawing.strokes {
                var newStroke = PKStroke(ink: stroke.ink, path: stroke.path)
                newStroke.ink.color = .cyan
                newStrokes.append(newStroke)
                print("=== copy strokes: ", newStrokes)
            }
            self.canvasView.drawing.strokes = newStrokes
            print("=== end")
        }
    }

    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        print("=== canvasViewDrawingDidChange\n")
        findDrawingsInBox()
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
