import SwiftUI
import SwiftData

struct ContentView: View {
    @Query var notes: [Note]
    @Environment(\.modelContext) private var modelContext

    @State private var showingNewNoteSheet = false
    @State private var newTitle = ""
    @State private var newContent = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // Dirty gray background covering entire screen
                Color(red: 200/255, green: 200/255, blue: 200/255)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Custom header
                    CustomHeaderView()
                        .frame(height: 80)

                    if notes.isEmpty {
                        Spacer()
                        VStack {
                            Text("No notes yet")
                                .font(.system(.title2, design: .monospaced))
                                .foregroundColor(Color.black.opacity(0.6))
                            Text("Tap the + button to create one.")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(Color.black.opacity(0.5))
                        }
                        Spacer()
                    } else {
                        List {
                            ForEach(notes) { note in
                                NavigationLink(destination: NoteDetailView(note: note)) {
                                    NoteCard(note: note)
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    let note = notes[index]
                                    modelContext.delete(note)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)           // Clear default list background
                        .scrollContentBackground(.hidden)  // Hide scrollview background
                    }
                }

                // Floating + button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Button(action: {
                                showingNewNoteSheet = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 36))
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(Color(red: 153/255, green: 0/255, blue: 51/255)) // purple-red
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                            }
                            Text("ADD")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(red: 0/255, green: 38/255, blue: 77/255))
                        }
                        .padding(.bottom, 20) // Move button up a bit
                        .padding(.trailing, 30)
                    }
                }
                RoundedRectangle(cornerRadius: 60)
                    .stroke(Color.white, lineWidth: 6)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $showingNewNoteSheet) {
                NewNoteSheet(
                    showingNewNoteSheet: $showingNewNoteSheet,
                    newTitle: $newTitle,
                    newContent: $newContent,
                    modelContext: modelContext
                )
            }
            .navigationBarHidden(true)
        }
    }
}

struct NoteCard: View {
    var note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.system(.headline, design: .monospaced))
                .foregroundColor(.black)
            Text(note.content)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.black.opacity(0.8))
                .lineLimit(1)  // Limit content to 1 line
        }
        .padding(10)
        .frame(maxWidth: 400)
        .background(Color(red: 224/255, green: 240/255, blue: 141/255))
        .border(Color.black, width: 2)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
        .frame(maxWidth: .infinity)
    }
}

struct CustomHeaderView: View {
    var body: some View {
        ZStack {
            Color(red: 200/255, green: 200/255, blue: 200/255)
                .edgesIgnoringSafeArea(.top)
            Text("HAYAI Notes")
                .font(.custom("PressStart2P-Regular", size: 36))
                .foregroundColor(Color(red: 0/255, green: 38/255, blue: 77/255))
                .kerning(-1)
                .shadow(color: Color.black.opacity(0.6), radius: 2, x: 1, y: 1)
                .padding(.top, 30)
        }
        .frame(maxWidth: .infinity)
    }
}

struct NewNoteSheet: View {
    @Binding var showingNewNoteSheet: Bool
    @Binding var newTitle: String
    @Binding var newContent: String
    var modelContext: ModelContext

    var body: some View {
        ZStack {
            // Dirty gray background
            Color(red: 200/255, green: 200/255, blue: 200/255)
                .ignoresSafeArea()

            NavigationStack {
                Form {
                    Section(header: Text("Title")) {
                        TextField("Enter title", text: $newTitle)
                            .font(.system(.body, design: .monospaced))
                    }
                    Section(header: Text("Content")) {
                        TextEditor(text: $newContent)
                            .frame(height: 150)
                            .font(.system(.body, design: .monospaced))
                    }
                }
                .navigationTitle("New Note")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            let newNote = Note(title: newTitle, content: newContent)
                            modelContext.insert(newNote)
                            showingNewNoteSheet = false
                            newTitle = ""
                            newContent = ""
                        }
                        .disabled(newTitle.isEmpty || newContent.isEmpty)
                    }

                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingNewNoteSheet = false
                            newTitle = ""
                            newContent = ""
                        }
                    }
                }
                .colorScheme(.light)
            }
        }
    }
}

