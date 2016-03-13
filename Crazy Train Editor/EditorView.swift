

import Cocoa

let COL_COUNT = 64
let ROW_COUNT = 40

let MARGIN_LEFT = 4
let MARGIN_TOP = 4
let TILE_SIZE = 2

class EditorView: NSView {
    var tileWidth: CGFloat = 0
    var tileHeight: CGFloat = 0
    var trackingArea: NSTrackingArea!
    var paths: [Path] = []
    var mouseLocation: CGPoint = CGPointMake(0, 0)
    var mouseDownLocation: CGPoint = CGPointMake(0, 0)
    var isEditing = false
    var typeButton = Type.road
    var downOnExistingPoint = false
    var downOnExistingPath = false
    var selectedPath = -1
    var drag = false
    var addNewCurve = false
    
    @IBAction func typeDidChange(sender: NSPopUpButton) {
        let type = sender.titleOfSelectedItem!
        
        switch type {
        case "road":
            typeButton = Type.road
            
        case "rail":
            typeButton = Type.rail
            
        case "walk":
            typeButton = Type.walk
            
        case "cross":
            typeButton = Type.cross
            
        case "crazy ped":
            typeButton = Type.crazyPedestrian
            
        case "garbage":
            typeButton = Type.garbage
            
            
            
        default:
            typeButton = Type.road
        }
        
        isEditing = false
    }
    
    @IBAction func stopEditing(sender: NSButton) {
        isEditing = false
    }
    @IBAction func newCurve(sender: NSButton) {
        isEditing = false
        addNewCurve = true
    }
    
    
    func setup(size: NSSize) {
        
        self.tileWidth = size.width / CGFloat(COL_COUNT)
        self.tileHeight = size.height / CGFloat(ROW_COUNT)
        Swift.print(tileWidth)
        Swift.print(tileHeight)
        // set window size to device size + 4 col and 4 row each side
        self.window?.setContentSize (NSSize(width: size.width + 2*(CGFloat(MARGIN_LEFT) * self.tileWidth), height: size.height + 2*(CGFloat(MARGIN_TOP) * self.tileHeight)))
        self.window?.center()
        
        
        // Set up the tracking area
        if self.trackingArea != nil {
            self.removeTrackingArea(self.trackingArea)
        }
        
        trackingArea = NSTrackingArea(rect: self.bounds, options: [NSTrackingAreaOptions.ActiveInKeyWindow, NSTrackingAreaOptions.MouseMoved], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
        //setData("~/Desktop/test.json")
        setData("/Users/CostaA17/Desktop/test.json")
    }
    func setData(path: String){
        Swift.print("setData")
        var points: [CGPoint] = []
        var pathArray: [[CGPoint]] = []
        
        do {
            let contents = try NSString(contentsOfFile: path, usedEncoding: nil) as String
            
            if let data = contents.dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    let dic = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
                    let pathsArray = dic!["paths"]// array of dictionaries
                    for path in pathsArray as! NSArray{
                        let pointsArray = path["points"] as! NSArray // array of CGPoint arrays
                        for curve in pointsArray{
                            for p in curve as! NSArray{
                                
                                let point = p as! NSArray
                                let flx = CGFloat(point[0].floatValue)
                                let fly = CGFloat(point[1].floatValue)
                                let makePoint = (CGPointMake(flx , fly ))
                                let x: CGFloat = (CGFloat(MARGIN_LEFT) + makePoint.x) * CGFloat(tileWidth)
                                let y: CGFloat = (CGFloat(MARGIN_TOP) + makePoint.y) * CGFloat(tileHeight)
                                points.append(CGPointMake(x , y))
                                
                            }
                            pathArray.append(points)
                            points = []
                        }
                        
                        let typeString = path["Type"]
                        
                        switch typeString as! String{
                        case "road":
                            paths.append(Path(type: Type.road, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
                        case "rail":
                            paths.append(Path(type: Type.rail, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
                        case "walk":
                            paths.append(Path(type: Type.walk, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
                        case "cross":
                            paths.append(Path(type: Type.cross, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
                        case "crazyPedestrian":
                            paths.append(Path(type: Type.crazyPedestrian, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
                        case "garbage":
                            paths.append(Path(type: Type.garbage, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
                        default: break
                            
                        }
                        
                        
                        
                    }
                    
                }catch{
                    
                }
            }
        } catch let error as NSError {
            Swift.print(error)
            
            // contents could not be loaded
        }
        
    }
    
    /*func setData(){
    let data = ""
    
    let indexes = data.characters.split("/").map() {String($0)} // get each path
    for(var i = 0; i < indexes.count; i++){
    
    var pathArray: [[CGPoint]] = []
    var points: [CGPoint] = []
    let typeString = indexes[i].characters.split(":").map() {String($0)}
    let pathAString = typeString[1].characters.split("#").map() {String($0)}
    
    //let pointsString = pathAString[1].characters.split("@").map() {String($0)}
    for a in pathAString{
    let pointsString = a.characters.split("@").map() {String($0)}
    
    for var p = 0; p < pointsString.count; p = p + 1{
    
    let xyString = pointsString[p].characters.split(",").map() {String($0)}
    let flx = CGFloat((xyString[0] as NSString).floatValue)
    let fly = CGFloat((xyString[1] as NSString).floatValue)
    let point = (CGPointMake(flx , fly ))
    let x: CGFloat = (CGFloat(MARGIN_LEFT) + point.x) * CGFloat(tileWidth)
    let y: CGFloat = (CGFloat(MARGIN_TOP) + point.y) * CGFloat(tileHeight)
    points.append(CGPointMake(x , y))
    }
    pathArray.append(points)
    points = []
    }
    
    // create the Path
    if typeString[0] == "road"{
    paths.append(Path(type: Type.road, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
    }
    
    if typeString[0] == "rail"{
    paths.append(Path(type: Type.rail, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
    
    }
    
    if typeString[0] == "walk"{
    paths.append(Path(type: Type.walk, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
    
    }
    
    if typeString[0] == "cross"{
    paths.append(Path(type: Type.cross, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
    
    }
    if typeString[0] == "crazyPedestrian"{
    paths.append(Path(type: Type.crazyPedestrian, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
    
    }
    if typeString[0] == "garbage"{
    paths.append(Path(type: Type.garbage, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: pathArray))
    
    }
    
    
    }
    
    
    }*/
    
    
    func newPoint(point: CGPoint) -> CGPoint{
        return CGPointMake(floor(point.x / tileWidth) * tileWidth, floor(point.y / tileHeight) * tileHeight)
    }
    
    func centerPoint(point: CGPoint) -> CGPoint{
        return CGPointMake((floor(point.x / tileWidth) * tileWidth) + tileWidth, (floor(point.y / tileHeight) * tileHeight) + tileHeight)
    }
    
    override func mouseMoved(theEvent: NSEvent) {
        let pointInView = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        mouseLocation = newPoint(pointInView)
        self.setNeedsDisplayInRect(self.bounds)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let pointInView = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        
        //test if is an existing point of the path array of one of the paths
        downOnExistingPoint = false
        for var i = 0; i < paths.count; i = i + 1{
            for var j = 0; j < paths[i].path.count; j = j + 1{
                for var k = 0; k < paths[i].path[j].count; k = k + 1{
                    if paths[i].path[j][k] == newPoint(pointInView){
                        downOnExistingPoint = true
                        drag = false
                        break
                    }
                }
            }
        }
        
        // if it's not on an existing point of the path array, test if it is on a path
        downOnExistingPath = false
        selectedPath = -1
        if !downOnExistingPoint{
            for var i = 0; i < paths.count; i = i + 1{
                let pathToTest = CGPathCreateCopyByStrokingPath(paths[i].buildCGPath(), nil, 26, CGLineCap.Square, CGLineJoin.Round, 0)
                if CGPathContainsPoint(pathToTest, nil , centerPoint(pointInView), false){
                    downOnExistingPath = true
                    selectedPath = i
                }
            }
        }
        
        if self.isEditing && !downOnExistingPoint && !downOnExistingPath{
            //add point to the last item of the path array of the last item of the paths array
            paths[paths.count - 1].path[paths[paths.count - 1].path.count - 1].append(newPoint(mouseLocation))
            if self.paths[paths.count - 1].path[paths[paths.count - 1].path.count - 1].count == 4 {
                // Exit out of editing mode
                //var myArray: [CGPoint] = []
                //myArray.append(paths[paths.count - 1].path[paths[paths.count - 1].path.count - 1][1])
                //paths[paths.count - 1].path.append(myArray)
                addNewCurve = true
                
            }
            
        }
        if !downOnExistingPoint && !downOnExistingPath{
            if !isEditing || addNewCurve{
                self.mouseLocation = pointInView
                if !addNewCurve{
                    // Create a new path at the end of the paths array
                    let array: [[CGPoint]] = []
                    self.paths.append(Path(type: typeButton, tileWidth: tileWidth, tileHeight: tileHeight, pointsArray: array))
                    //add point to the last item of the path array of the last item of the paths array
                    paths[paths.count - 1].path[paths[paths.count - 1].path.count - 1].append(newPoint(mouseLocation))
                }else{
                    var myArray: [CGPoint] = []
                    myArray.append(paths[paths.count - 1].path[paths[paths.count - 1].path.count - 1][1])
                    paths[paths.count - 1].path.append(myArray)
                    paths[paths.count - 1].path[paths[paths.count - 1].path.count - 1 ].append(newPoint(mouseLocation))
                }
                self.addNewCurve = false
                self.isEditing = true
            }
        }
        self.setNeedsDisplayInRect(self.bounds)
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        let pointInView = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        if downOnExistingPoint{
            // test what point
            for var i = 0; i < paths.count; i = i + 1{
                for var j = 0; j < paths[i].path.count; j = j + 1{
                    for var k = 0; k < paths[i].path[j].count; k = k + 1{
                        if paths[i].path[j][k] == mouseLocation{
                            //move it
                            paths[i].path[j][k] = newPoint(pointInView)
                            mouseLocation = newPoint(pointInView)
                            drag = true
                        }
                    }
                }
            }
            self.setNeedsDisplayInRect(self.bounds)
        }else if downOnExistingPath{
            for var j = 0; j < paths[selectedPath].path.count; j = j + 1{
                for var k = 0; k < paths[selectedPath].path[j].count; k = k + 1{
                    let newPath = CGPointMake((paths[selectedPath].path[j][k].x) + theEvent.deltaX , (paths[selectedPath].path[j][k].y) - theEvent.deltaY)
                    self.paths[selectedPath].path[j][k] = newPath
                    self.setNeedsDisplayInRect(self.bounds)
                }
            }
        }
    }
    
    override func mouseUp(theEvent: NSEvent) {
        if downOnExistingPath{
            for var j = 0; j < paths[selectedPath].path.count; j = j + 1{
                for var k = 0; k < paths[selectedPath].path[j].count; k = k + 1{
                    self.paths[selectedPath].path[j][k] = newPoint(self.paths[selectedPath].path[j][k])
                }
                self.setNeedsDisplayInRect(self.bounds)
            }
        }
        if downOnExistingPoint && !drag{
            for var i = 0; i < paths.count; i = i + 1{
                for var j = 0; j < paths[i].path.count; j = j + 1{
                    for var k = 0; k < paths[i].path[j].count; k = k + 1{
                        if paths[i].path[j][k] == mouseLocation{
                            //move it
                            paths[i].path[j].removeAtIndex(k)
                            self.setNeedsDisplayInRect(self.bounds)
                            downOnExistingPoint = false
                        }
                    }
                }
            }
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        let deviceSize = NSSize(width: ((self.bounds.size.width/CGFloat(COL_COUNT + (2 * MARGIN_LEFT))) * CGFloat(COL_COUNT)),height:((self.bounds.size.height/CGFloat(ROW_COUNT + (2 * MARGIN_TOP))) * CGFloat(ROW_COUNT)))
        NSColor.whiteColor().set()
        NSRectFill(self.bounds)
        
        // Draw grid
        NSColor.lightGrayColor().set()
        for var col = 0; col < COL_COUNT + 8; col++ {
            NSRectFill(NSRect(x: CGFloat(col) * tileWidth, y: 0, width: 1, height: self.bounds.height))
        }
        for var row = 0; row < ROW_COUNT + 8; row++ {
            NSRectFill(NSRect(x: 0, y: CGFloat(row) * tileHeight, width: self.bounds.width, height: 1))
        }
        // Draw device limits
        NSColor.blackColor().set()
        NSRectFill(NSRect(x: CGFloat(4) * tileWidth, y: tileHeight * 4, width: 2, height: deviceSize.height))
        NSRectFill(NSRect(x: CGFloat(68) * tileWidth, y: tileHeight * 4, width: 2, height: deviceSize.height))
        NSRectFill(NSRect(x: tileWidth * 4, y: CGFloat(4) * tileHeight, width: deviceSize.width, height: 2))
        NSRectFill(NSRect(x: tileWidth * 4, y: CGFloat(24) * tileHeight, width: deviceSize.width, height: 1))
        NSRectFill(NSRect(x: tileWidth * 4, y: CGFloat(44) * tileHeight, width: deviceSize.width, height: 2))
        NSRectFill(NSRect(x: CGFloat(36) * tileWidth, y: tileHeight * 4, width: 1, height: deviceSize.height))
        
        
        // Draw current tile
        let point = newPoint(mouseLocation)
        NSColor.redColor().set()
        NSRectFill(NSRect(x: point.x, y: point.y, width: tileWidth * CGFloat(TILE_SIZE), height: tileHeight * CGFloat(TILE_SIZE)))
        
        // Draw paths
        let ctx: CGContextRef = NSGraphicsContext.currentContext()!.CGContext
        for var i = 0; i < paths.count; i = i + 1{
            paths[i].draw(ctx)
        }
    }
    
    func buildData() -> Dictionary<String, AnyObject>{
        var dataDictionary = [String: AnyObject]()
        dataDictionary["rows"] = ROW_COUNT
        dataDictionary["cols"] = COL_COUNT
        var pathsArray: [Dictionary<String, AnyObject>] = []
        for path in paths{
            pathsArray.append(path.buildData())
        }
        dataDictionary["paths"] = pathsArray
        return dataDictionary
    }
    
}

