# View Update 🔨 
- Due to the separation of initial construction of views and updating view when events happen,  along with manual updating involved, it’s easy to make mistakes that updating the views in response to an event but forget to update the model, or vice versa.  In the end, the view gets out of sync. 

- SwiftUI has been designed to entirely avoid this category of problems. 
	1. A single code path that constructs the initial views and used for all subsequent updates (view’s `body` property)
	2. It’s impossible to bypass the normal view update cycle and modify the view tree directly. Only way is to triggering a reevaluation of the `body`  property. 

- Instead of simply throw everything away and redraw the screen from scratch, SwiftUI needs to know which of the underlying view objects need to be changed, added, or or removed. In order to achieve efficiency, swiftUI needs the view tree have the same structure every time. 
	- If the old tree and new tree are guaranteed to have the same structure, SwiftUI could efficiently update the display without reconstructing and redrawing everything from scratch. 
	- Talking about tree diffing algorithms, have a complexity of  O(n^3), in order to manage the complexity,  framework like react using heuristic diffing algorithm with O(n) complexity, which trades precision of the diff for performance. 
	- SwiftUI doesn’t need to perform a full tree diff. 
	
- Isn’t it still wasteful to recreate and compare the entire view tree value each time? 
	- SwiftUI keeps track of which views use which state variables, it only re-executes the `body` of a view that uses @State property(same for other property wrappers, such as @ObservedObject and @Environment).
	- In theory, this also invalidates the entire subtree of the changed view, but SwiftUI optimises the process, it avoids re-executing a subview’s body when it knows the subview hasn’t changed.
	
- How to dynamically swap out parts of the view tree or insert views that we didn’t know about at compile time. 
	- **if/else** conditions. Most restrictive option in view builders for dynamically changing what’s onscreen at runtime. 
	- **ForEach.** The number of views can change, but they all need to have the same type. Most commonly used with Lists.  
```
struct ForEach<Data, ID, Content> where Data : RandomAccessCollection, ID : Hashable	
```

			- **Data**: could be any `RandomAccessCollection`
			
			- **ID**: a key path that specifies which property should be used to identify an element(the collection’s elements have to either conform to the Identifiable protocol, or we have to specify a keypath to an identifier)
			
			- **Content**: construct a view from an element in the collection. 
			
> *Since ForEach requires each element to be identifiable, it can figure out at runtime (by computing a diff) which views have been added or removed since the last view update. While this is more work than evaluating if/else conditions for dynamic subtrees, it still allows SwiftUI to be smart about updating what’s onscreen. Also, uniquely identifying elements helps with animations, even when the properties of an element change.*

	- **AnyView** . AnyView is a view that can be initialised with any view to erase the wrapped view’s type. This means that an AnyView can contain completely arbitrary view trees with no requirement that their type be statically fixed at compile time. While this gives us a lot of freedom, AnyView should be something we only use as a last resort. This is because using AnyView takes away essential static type information about the view tree that otherwise helps SwiftUI perform efficient updates

- How and where we use state properties that triggers view updates?
	- In general terms: SwiftUI tracks which views use which state properties, and on view updates, SwiftUI only executes the bodies of the views that could actually have changed. 
	- We place state properties as locally as possible. 
	- Conversely, it’s the worst possible on the root view and pass all data down the view tree in the form of simple parameters, as this will cause many more views to be needlessly reconstructed. 
	
- All the property wrappers SwiftUI uses for triggering view updates conform to the DynamicProperty protocol. 
	- Binding
	- Environment
	- EnvironmentObject
	- FetchRequest
	- GestureState
	- ObservedObject
	- State 

- Property Wrappers makes SwiftUI more readable. 
- Property wrappers also enable dependency tracking.  When a view’s body accesses the wrappedValue of a State variable, a dependency is added between the view and the state variable. -> SwiftUI knows which views to update when the wrappedValue changes. 
- @State is great for representing local view state, such as state we might have to track in a small component. 
- Once we need to store and observe that states of the control, simply change @State to @Binding, which doesn’t require any other changes to the code. 
- We don’t need to create a binding to the entire state value; We can also create a binding to a property of a state value.  For example ($state.volume) or $volumes[0]
- @GestureState is for gesture recognisers. It’s initialised with an initial value and then get updated while gesture is ongoing. Once the gesture has finished, the gesture state property is automatically reset to its initial value. 


#SwiftUI