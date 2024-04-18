import SwiftUI

struct AddFoodView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var desc = ""
    @State private var dueDate = Date()
    @State private var isDone = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Task Details")) {
                    TextField("Your Task", text: $name)
                        .padding()
                    
                    TextField("Description", text: $desc) // Add TextField for the "desc" field
                        .padding()
                    
                    DatePicker("Due Date", selection: $dueDate, in: Date()..., displayedComponents: .date)
                }
                
                Section {
                    Button("Add") {
                        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            errorMessage = "Task name cannot be empty"
                        } else {
                            DataController().addFood(
                                name: name,
                                desc: desc,
                                dueDate: dueDate,
                                isDone: isDone,
                                context: managedObjContext)
                            dismiss()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue) // Set color for error message
                    .padding(.top, 5)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .background(Color("PrimaryColor"))
            .navigationTitle("Add Todo")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
            )
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddFoodView().preferredColorScheme(.dark)
    }
}
