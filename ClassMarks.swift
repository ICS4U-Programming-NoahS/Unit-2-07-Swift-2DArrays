//
// ClassMarks.swift
//
// Created by Noah Smith
// Created on 2025-04-01
// Version 1.0
// Copyright (c) 2025 Noah Smith. All rights reserved.
//
// The ClassMarks program reads students.txt and assignments.txt.
// It saves the data from each of the files into 2 separate arrays of strings.
// It calls the function GenerateMarks that will take 2 the arrays as arguments.
// It outputs the results to a CSV file called marks.csv
// The function called generateMarks will randomly generate all the marks.
// The mean is 75 and the standard deviation is 10.

// Import foundation library
import Foundation

// Declare constants for the maximum and minimum possible marks
let maxMark = 100
let minMark = 0

// This is the generate marks function that returns a 2D array of strings
func generateMarks(arrayAssignments: [String], arrayStudents: [String]) -> [[String]] {

    // Create a 2D array initialized with empty strings
    var marks = Array(repeating: Array(repeating: "", count: arrayAssignments.count), count: arrayStudents.count)

    // Iterate through the array of student names
    for studentIndex in 0..<arrayStudents.count {
        // Iterate through the array of assignments
        for assignmentIndex in 0..<arrayAssignments.count {

            // Generate two random numbers for Box-Muller transform
            let random1 = Double.random(in: 0...1)
            let random2 = Double.random(in: 0...1)
            let multiplier = sqrt(-2 * log(random1)) * cos(2 * .pi * random2)

            // Generate a mark using a normal distribution with mean=75 and stdDev=10
            let mark = Int(75 + 10 * multiplier)

            // Ensure that the mark is clamped between MinMark and MaxMark
            marks[studentIndex][assignmentIndex] = String(max(minMark, min(maxMark, mark)))
        }
    }

    // Return the generated 2D array of marks
    return marks
}

// Declare the paths to the students and assignments files
let studentsFile = "./students.txt"
let assignmentsFile = "./assignments.txt"

// Read the list of students from the file
let studentsList = try String(contentsOfFile: studentsFile).split(separator: "\n")

// Read the list of assignments from the file
let assignmentsList = try String(contentsOfFile: assignmentsFile).split(separator: "\n")

// Convert the lists to arrays of strings
let arrayStudents = studentsList
let arrayAssignments = assignmentsList

// Call generateMarks to generate a 2D array of marks for students and assignments
// init converts each element to a string
// source: https://stackoverflow.com/questions/35323151/swift-dictionary-map-init-in-closure
let marks = generateMarks(
    arrayAssignments: arrayAssignments.map(String.init), arrayStudents: arrayStudents.map(String.init)
    )

// Specify the path for the output CSV file
let filePath = "./Marks.csv"

// Create an empty file at the specified path
FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)

// Open the file for writing
let fileHandle = try FileHandle(forWritingTo: URL(fileURLWithPath: filePath))

// Write the header row (Assignments) to the CSV file
var header = "Student Name"

// Append each assignment name to the header row, separated by a comma
for assignment in arrayAssignments {
    header += ", \(assignment)"
}

// Write the header row to the CSV file
fileHandle.write(Data("\(header)\n".utf8))

// Write the marks for each student to the CSV file
for studentIndex in 0..<arrayStudents.count {
    // Start the line with the student's name
    var line = arrayStudents[studentIndex]

    // Append the marks for each assignment
    for assignmentIndex in 0..<arrayAssignments.count {
        line += ", \(marks[studentIndex][assignmentIndex])"
    }

    // Write the completed line for the student to the file
    fileHandle.write(Data("\(line)\n".utf8))
}

// Close the file writer to ensure all data is saved
fileHandle.closeFile()

// Display a success message to indicate the file has been written
print("The file has been written successfully.")
