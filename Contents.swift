import Foundation

// Generics used to avoid writing the same function multiple times or
// writing the same code multiple times

func performInt(_ op: (Int, Int) -> Int, on lhs: Int, and rhs: Int) -> Int {
    op(lhs, rhs)
}

performInt(+, on: 20, and: 10)
performInt(-, on: 20, and: 10)
performInt(*, on: 20, and: 10)
performInt(/, on: 20, and: 10)


func performDouble(_ op: (Double, Double) -> Double, on lhs: Double, and rhs: Double) -> Double {
    op(lhs, rhs)
}

performDouble(+, on: 20.2, and: 10.2)
performDouble(-, on: 20.2, and: 10.2)
performDouble(*, on: 20.2, and: 10.2)
performDouble(/, on: 20.2, and: 10.0)

// Bu yazım şekli Generic olur. Numeric bir protocol'dür. İçinde Int ve Double veri tipini bulundurur.
// Yukarıdaki iki ayrı fonksiyonu bir fonksiyonda toplamış olduk.

/*
func perform<Numeric>(_ op: (Numeric, Numeric) -> Numeric, on lhs: Numeric, and rhs: Numeric) -> Numeric {
    op(lhs, rhs)
}
*/

// Tipini önceden belirterek kısaltma yapabiliriz.
func perform<N: Numeric>(_ op: (N, N) -> N, on lhs: N, and rhs: N) -> N {
    op(lhs, rhs)
}

let x = perform(+, on: 20, and: 10)
x // x in veri tipi int generic bunu algılar

let y = perform(-, on: 20.2, and: 10.0)
y // y nin veri tipi double generic bunu algılar.


// ya da aynı anlama gelen farklı tarz yazılmış hali, (alternative way writing to the generics)

func perform2<N>(_ op: (N, N) -> N, on lhs: N, and rhs: N) -> N where N: Numeric {
    op(lhs, rhs)
}

perform2(+, on: 20, and: 10)
perform2(-, on: 20.2, and: 10.0)

// *****************************************************************

protocol CanJump {
    func jump()
}

protocol CanRun {
    func run()
}

struct Person: CanJump, CanRun {
    func jump() {
        "Jumping..."
    }
    
    func run() {
        "Running..."
    }
}

// you have access to jump and run functions
// This is a way of combining multiple protocols in order to create a generic function
func jumpAndRun<T: CanJump & CanRun>(_ value: T) {
    value.jump()
    value.run()
}

let person = Person()
jumpAndRun(person)

// *****************************************************************

// you can also have extensions on generic types
// one generic type that is very useful 'arrays'

// let name: [String] = ["Foo", "Baz"]  different way to writing
let name: Array<String> = ["Foo", "Baz"]

/*
extension Array where Element == String {
    
    this is old syntax; Array where Element == String
}
*/

extension [String] { // or extension Array<String> {
    func longestString() -> String? {
        self.sorted { (lhs: String, rhs: String) -> Bool in
            lhs.count > rhs.count
        }.first
    }
}

["Foo", "Bar Baz", "Qux"].longestString()


extension [Int] {
    func average() -> Double {
        Double(self.reduce(0, +)) / Double(self.count)
    }
}

[1,2,3,4].average()




// *****************************************************************

// Generic protocols (Advanced topic)

protocol View {
    func addSubView(_ view: View)
}

extension View {
    func addSubView(_ view: View) {
        // empty
    }
}

struct Button: View {
    // empty
}

protocol PresentableAsView {
    // if you want to turn a protocol to a generic protocol you use a syntax or a keyword called Associated type and
    // using Associated type is almost as if you say presentable ads view has some sort of a generic parameter
    
    associatedtype ViewType: View
    func produceView() -> ViewType
    func configure(superView: View, thisView: ViewType)
    func present(view: ViewType, on superView: View)
    func doSomethingWithButton() -> String
}

extension PresentableAsView { // this is a generic protocol simply because it has an Associated type
    
    func configure(superView: View, thisView: ViewType) {
        // empty by default
    }
    
    func present(view: ViewType, on superView: View) {
        superView.addSubView(view)
    }
}

struct MyButton: PresentableAsView {
   
    func produceView() -> Button {
        Button()
    }
    
    func configure(superView: View, thisView: Button) {
        
    }
}

extension PresentableAsView where ViewType == Button {
    
    func doSomethingWithButton() -> String {
        "This is a button"
    }
}

let button = MyButton()
button.doSomethingWithButton()




