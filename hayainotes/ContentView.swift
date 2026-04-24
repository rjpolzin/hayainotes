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
                Color(red: 200/255, green: 200/255, blue: 200/255)
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    CustomHeaderView()
                        .frame(height: 85)

                    if notes.isEmpty {
                        Spacer()

                        Text("NO NOTES YET")
                            .font(.system(size: 22, weight: .bold, design: .monospaced))
                            .foregroundColor(.black.opacity(0.5))

                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 18) {
                                ForEach(notes) { note in
                                    NavigationLink(destination: NoteDetailView(note: note)) {
                                        NoteCard(note: note)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 120)
                        }
                    }
                }

                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        VStack(spacing: 6) {
                            Button(action: {
                                showingNewNoteSheet = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.blue)
                                    .frame(width: 88, height: 88)
                                    .background(Color(red: 153/255, green: 0/255, blue: 51/255))
                                    .clipShape(Circle())
                                    .shadow(radius: 8)
                            }

                            Text("ADD")
                                .font(.system(size: 20, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))
                        }
                        .padding(.trailing, 26)
                        .padding(.bottom, 18)
                    }
                }
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
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text(note.title)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .lineLimit(2)

            Text(note.content)
                .font(.system(size: 16, design: .monospaced))
                .foregroundColor(.black.opacity(0.7))
                .lineLimit(2)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 224/255, green: 240/255, blue: 141/255))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.black, lineWidth: 2)
        )
        .cornerRadius(18)
        .shadow(radius: 4)
        .padding(.horizontal, 18)
    }
}

struct CustomHeaderView: View {
    var body: some View {
        ZStack {
            Color(red: 200/255, green: 200/255, blue: 200/255)

            Text("HAYAI Notes")
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))
                .shadow(radius: 4)
        }
    }
}

struct NewNoteSheet: View {
    @Binding var showingNewNoteSheet: Bool
    @Binding var newTitle: String
    @Binding var newContent: String
    var modelContext: ModelContext

    @State private var showingShareSheet = false

    var body: some View {
        ZStack {
            Color(red: 200/255, green: 200/255, blue: 200/255)
                .ignoresSafeArea()

            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        Text("TITLE")
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))

                        TextField("Enter title", text: $newTitle)
                            .padding()
                            .background(Color(red: 224/255, green: 240/255, blue: 141/255))
                            .cornerRadius(14)
                            .font(.system(size: 22, design: .monospaced))
                            .foregroundColor(.black)

                        Text("CONTENT")
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))

                        TextEditor(text: $newContent)
                            .font(.system(size: 20, design: .monospaced))
                            .foregroundColor(.black)
                            .scrollContentBackground(.hidden)
                            .padding()
                            .frame(height: 380)
                            .background(Color(red: 224/255, green: 240/255, blue: 141/255))
                            .cornerRadius(14)
                    }
                    .padding()
                }

                Spacer()

                HStack(spacing: 34) {

                    VStack(spacing: 8) {
                        Button(action: {
                            showingNewNoteSheet = false
                            newTitle = ""
                            newContent = ""
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.blue)
                                .frame(width: 70, height: 70)
                                .background(Color(red: 153/255, green: 0/255, blue: 51/255))
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }

                        Text("CANCEL")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))
                    }

                    VStack(spacing: 8) {
                        Button(action: {
                            showingShareSheet = true
                        }) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 70, height: 70)
                                .background(Color(red: 0/255, green: 38/255, blue: 89/255))
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }

                        Text("SEND")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))
                    }

                    VStack(spacing: 8) {
                        Button(action: {
                            let newNote = Note(title: newTitle, content: newContent)
                            modelContext.insert(newNote)

                            showingNewNoteSheet = false
                            newTitle = ""
                            newContent = ""
                        }) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.blue)
                                .frame(width: 70, height: 70)
                                .background(Color(red: 153/255, green: 0/255, blue: 51/255))
                                .clipShape(Circle())
                                .shadow(radius: 8)
                        }

                        Text("SAVE")
                            .font(.system(size: 18, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 0/255, green: 38/255, blue: 89/255))
                    }
                }
                .padding(.bottom, 28)
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ActivityView(activityItems: ["\(newTitle)\n\n\(newContent)"])
        }
        .colorScheme(.light)
    }
}
