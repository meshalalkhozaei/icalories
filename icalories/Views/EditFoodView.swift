import SwiftUI
struct EditFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var food: FetchedResults<Food>.Element
    
    @State private var name = ""
    @State private var desc = ""
    @State private var calories: Double = 0
    @State private var dueDate = Date()
    @State private var isDone = false
    
    
    var body: some View {
        List {
            Section(header: Text("Task Details")) {
                TextField("Your Task", text: $name)
                    .padding()
                
                TextField("Description", text: $desc) // Add TextField for the "desc" field
                    .padding()
                
                DatePicker("Due Date", selection: $dueDate, in: Date()..., displayedComponents: .date)
            }
            
            HStack {
                Spacer()
                Button("Edit") {
                    DataController().editFood(food: food, name: name, desc: desc, dueDate: dueDate, isDone: isDone, context: managedObjContext)
                    dismiss()
                }.frame(maxWidth: .infinity , alignment: .center)
                Spacer()
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("PrimaryColor"))
    }
}


struct EditFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView()
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}
