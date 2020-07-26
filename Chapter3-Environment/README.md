# Environment 🌲
### Overall 
It is the mechanism SwiftUI uses to propagate values down the view tree, i.e. from a parent view to its contained subview tree.

### How the Environment Works

if print out the concrete type of the following view. 
```
var body: some View {
	VStack {
		Text("Hello World")
	}
	.font(Font.headline)
}
```

We can how the type changes: 

```
ModifiedContent<
VStack<Text>,
_EnvironmentKeyWritingModifier<Optional<Font>>
>
```

The type tells us that `.font` call that, an optional `Font` value is written to the environment. Since the environment is passed down the view tree, the textLabel within the stack can read the font value from the environment. 

- Even though setting a font on a vertical stack doesn’t make immediate sense, the font setting is not lost; It’s preserved via the environment for any child view in the tree that might actually be interested in it. 
- The environment becomes especially useful when we want to modify multiple views at once. For example, 
```
VStack {
	Text("text 1")
	HStack {
		Text("text 2")
		Text("text 3")
	}.font(.largeTitle)
}
```

**The environment modifiers always only modify the environment of their direct subview tress and never the environment of sibling tress or parent views.** 

### Using the Environment 

- To make the custom control work nicely with both light appearance and dark appearance, we’ll use SwiftUI’s `colorScheme` environment value to read the current colour scheme setting from the environment and set the knob’s coloraturas accordingly: 
```
struct Knob: View {
	@Binding var value: Double 
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		KnobShape()
		.fill(colorScheme == .dark ? Color.white : Color.black)
		.....
	}
}
```

`@Environment` properties act like `@State` properties: when the value changes, a view update is triggered. 

### Custom Environment Values

- Define a new type conforming to the `EnvironmentKey` protocol: 
```
fileprivate struct PointerSizeKey: EnvironmentKey {
		static let defaultValue: CGFloat = 0.1 
}
``` 
- Add a property to `EnvironmentValues` so that we can use it as a key path: 
```
extension EnvironmentValues {
	var knobPointerSize: CGFloat {
		get { self[PointerSizeKey.self] }
		set { self[PointerSizeKey.self] = newValue }
	}
}
```
- **Environment decouples reading a configuration value from setting that value. As a result, it’s very easy to forget to set an environment value or to set it on the wrong view subtree. It’s better to start by exposing customisation options as simple view parameters, and then when noticing that a more decoupled API would be useful, it’s easy to change the implementation to use an environment values as well.** 

### Dependency injection 
- The environment is usually used with value types: a view depends on an environment value via an `@Environment` property is only invalidated when a new environment value is set for the key in question, if we store an object in the environment and observe it with `Environment`, the view will not be  invalidated if a property of the object changes - this only occurs if the entirely different object is set. 
- `environmentObject(_:)` modifier for injecting objects.
- While the `@EnvironmentObject` pattern is useful, it’s better to use `@Environment` with a key if it’s possible to get away with passing a value type, because it’s the safer mechanism: EnvironmentKey requires us to provide a default value. With @EnvironmentObject, it is almost too easy to end up with a hard crash if we forget to inject the object.

### Preferences 
- `Preference` system allows us to implicitly pass values from child views to a superview. 

#SwiftUI/Environment