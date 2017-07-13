//
//  ViewController.swift
//  sttt
//
//  Created by user on 06.07.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var eyeButton: UIButton!
    @IBOutlet weak var stepper: UIStepper!
    
    
    //var poem = ["Умом Россию не понять ,", "Аршином общим не измерить :", "У ней особенная стать –", "В Россию можно только верить ."]
    
    //---Переменная для стиха
    var poem = ["Когда - нибудь в молчании я простираю руку", "И детских укоризн в грядущем не страшусь .", "Ты втайне поняла души смешную муку ,", "Усталых прихотей ты разгадала скуку ;", "Мы вместе - и судьбе я молча предаюсь .", "Без клятв и клеветы ребячески - невинной", "Сказала жизнь за нас последний приговор .", "Мы оба молоды , но с радостью старинной", "Люблю на локон твой засматриваться длинный ;", "Люблю безмолвных уст и взоров разговор .", "Как в дни безумные , как в пламенные годы ,", "Мне жизни мировой святыня дорога ;", "Люблю безмолвие полунощной природы ,", "Люблю ее лесов лепечущие своды ,", "Люблю ее степей алмазные снега ."]
    var dataArrayForStep: [[String]] = [] //--- Массив, хранящий все вариации стиха в соответствии с шагом сокрытия слов
    var currentDisplay = [""] //---Массив со строками стиха, который показан на экране
    var currentRowArray = 0 //---Отслеживаем номер строки в стихе, на котором закончили прятать слова
    var flag = false //---Fлаг
    
    var countWords: Int {  //---Считаем кол-во слов в оригинале стиха
        var number = 0
        for i in self.poem {
            number += i.words.count  //---Считаем сколько в стихе слов
        }
        return number
    }
    
    var arrayChar: [[String]] = [] //---Массив частей каждой строки оригинала стиха
    var strForSelect = ""
    
    
    
    //---Функция: создание новой строки
    func createRow(array: [String]) -> String {
        var newRow = ""
        for word in array {
            newRow += word + " "
        }
        newRow.remove(at: newRow.index(before: newRow.endIndex))
        return newRow
    }
    //---
    
    //---Функция: заменить П**** на *****
    func replacementOfWordsInRow(arrayStr: inout [String]) -> String {
        //---Проверяем какой индекс у сегмента
        if segment.selectedSegmentIndex == 1 {
            for i in 0..<arrayStr.count {
                //---Условие: проверяем это слово П**** или нет
                if (arrayStr[i][arrayStr[i].index(before: arrayStr[i].endIndex)] == "\u{25AF}") && (arrayStr[i][arrayStr[i].startIndex] != "\u{25AF}") {
                    arrayStr[i].characters.removeFirst() //---Удаляем первый символ
                    arrayStr[i].insert("\u{25AF}", at: arrayStr[i].startIndex)  //---Вставляем символ прямоугольник
                }
                //---
            }
        }
        //---
        return createRow(array: arrayStr)
    }
    //---
    
    //---Функция: спрятать слова
    func hideWords(countWords: Int, arrayForTable: inout [String]) {
        //счетчик - сколько он реально закрыл слов
        var lol = 0
        
        var tempArrayWords = [""] //---Создаем временный пустой массив слов
        var hideWords = countWords //---Присваем новой переменной сколько надо спрятать слов
        //---Цикл: работает пока слова не будут спрятаны
        while hideWords > 0 {
            //---Проверяем, чтобы текущий номер строки в стихе не был больше числа всех строк этого стиха
            if currentRowArray == currentDisplay.count {
                currentRowArray = 0
            }
            //---
            var tempRow = currentDisplay[currentRowArray].components(separatedBy: " ") //---Массив частей текущей строки на экране
            //---Процедура по замене П**** на ***** в тех строках, в которых прячем слова
            tempArrayWords = replacementOfWordsInRow(arrayStr: &tempRow).words //---Заполняем массив оставшимися словами в текущей строке
            //---
            //---Проверяем: есть ли еще слова в текущей строке, которые можно спрятать
            if tempArrayWords.isEmpty {
                currentRowArray += 1 //---Если в строке слов нет, то мы перескакиваем на след. строку
            } else {
                let random = Int(arc4random_uniform((UInt32(tempArrayWords.count - 1)) + 1)) //---Получаем рандомный индекс в массиве оставшихся слов
                var newRow = "" //---Переменная для генерации новой строки
                //---Цикл: генерация новой строки после того, как спрятано слово
                for word in tempRow {
                    //---Условие: ищем слово, которое нужно спрятать, в массиве частей текущей строки
                    if tempArrayWords[random] == word {
                        lol += 1 //---Убрали одно слово
                        var newWord = "" //---Создаем новое слово
                        //---Цикл: Заменяем слово на *****
                        for _ in 0..<word.characters.count {
                            newWord += "\u{25AF}"
                        }
                        //---
                        newRow += newWord + " " //---Добавляем спрятанное слово
                    } else {
                        newRow += word + " " //---Добавляем нетронутое слово
                    }
                    //---
                }
                //---
                newRow.remove(at: newRow.index(before: newRow.endIndex)) //---Удаляем из новой строки последний символ " "
                arrayForTable[currentRowArray] = newRow //---Для данного массива стиха заменяем новую строку
                currentRowArray += 1 //---Переход на новую строку в стихе
                hideWords -= 1 //---Вычитаем одно спрятанно слово
            }
            //---
        }
        //---
        print("Я закрыл - \(lol) слов")
    }
    //---
    //---Функция для получения нового массива стиха в соответ. с каким-либо шагом
    func reloadTable(array: inout [String], numberCount: Int) {
        //---Проверяем: новый массив пустой или нет
        if array[0].isEmpty {
            hideWords(countWords: numberCount, arrayForTable: &array) //---Функция: спрятать слова
            //---Цикл:ловим строки, в которых не прятали слова
            for i in 0..<currentDisplay.count {
                //---Условие: если строка пустая, т.е. в ней мы слово не прятали
                if array[i].isEmpty {
                    var tempRow = currentDisplay[i].components(separatedBy: " ")
                    //---Процедура по замене П**** на ***** в тех строках, в которых слова не были спрятаны
                    array[i] = replacementOfWordsInRow(arrayStr: &tempRow) //---Вставляем обработанную строку в массив для текущего шага
                    //---
                }
                //---
            }
            //---
        }
        //---
        //---Условие: проверяем что показываем *****/П****
        if segment.selectedSegmentIndex == 0 {
            currentDisplay = array
        } else if segment.selectedSegmentIndex == 1 {
            transformationWithOneLetter(currentArray: array)
        }
        //---
    }
    //---
    func transformationWithOneLetter (currentArray: [String]) {
        var tempArrayChar: [[String]] = []  //---Временный массив частиц строк стиха для текущего шага
        var tempArray: [String] = []  //---Временый массив с измененными словами ***** на П****
        tempArray = currentArray  //---Сохраняем текущий вид стиха во временный массив, который потом будем менять
        //---Цикл: разбиваем текущий вид стиха на части всех строк
        for i in tempArray {
            tempArrayChar.append(i.components(separatedBy: " "))
        }
        //---
        //---Цикл: поиск и замена слова ***** на П****
        for row in 0..<tempArrayChar.count {
            for index in 0..<tempArrayChar[row].count {
                //--Условие: если нашли ***** и оно больше 1 символа
                if arrayChar[row][index] != tempArrayChar[row][index] && (arrayChar[row][index].characters.count > 1) {
                    let startIndex = String(arrayChar[row][index][arrayChar[row][index].startIndex])  //---Считываем 1 символ
                    var newWord = "" //---Создаем новое слово
                    newWord = startIndex //---Присваиваем новому слову первый букву
                    //---Цикл: закрываем остальные символы в слове прямоугольником
                    for _ in 0..<tempArrayChar[row][index].characters.count - 1 {
                        newWord += "\u{25AF}"
                    }
                    //---
                    tempArrayChar[row][index] = newWord  //---Заменяем исправленное слово
                }
                //---
            }
        }
        //---
        //---Цикл: создаем и присваем новые строки в массив с П****
        for row in 0..<tempArray.count {
            tempArray[row] = createRow(array: tempArrayChar[row])//newRow
        }
        //---
        currentDisplay = tempArray //---Отображаем массив на экран с П****
    }
    
    @IBAction func step(_ sender: UIStepper) {
        //let tempArrayWords = [""]
        let countHideWords = Int(ceil(Double(countWords) * (sender.value / 10))) //---Сколько нужно в сумме спрятать слов для текущего шага
        let curcur = Int(ceil(Double(countWords) * ((sender.value - sender.stepValue) / 10))) //---Сколько до этого шага было спрятано слов
        let hideWordsNumber = countHideWords - curcur  //---Сколько еще не спрятанных слов осталось для текущего шага
        
        print("Сколько закрытых букв - \(countHideWords)")
        
        print("\((sender.value / 10) * 100)%")
        
        //---Условие для активности кнопки Глаз
        sender.value > 0 ? (eyeButton.isEnabled = true) : (eyeButton.isEnabled = false)
        //---
        //---Свитч для определения значения на Stepper'е
        switch sender.value {
        case 0.0:
            currentDisplay = dataArrayForStep[0] //---Записываем на экран оригинал стиха
        case 1.25:
            reloadTable(array: &dataArrayForStep[1], numberCount: hideWordsNumber) //---Перезагружаем таблицу для 12,5% спрят. слов
        case 2.5:
            reloadTable(array: &dataArrayForStep[2], numberCount: hideWordsNumber) //---Перезагружаем таблицу для 25% спрят. слов
        case 3.75:
            reloadTable(array: &dataArrayForStep[3], numberCount: hideWordsNumber) //---Перезагружаем таблицу для 37,5% спрят. слов
        case 5.0:
            reloadTable(array: &dataArrayForStep[4], numberCount: hideWordsNumber) //---Перезагружаем таблицу для 50% спрят. слов
        case 6.25:
            reloadTable(array: &dataArrayForStep[5], numberCount: hideWordsNumber) //---Перезагружаем таблицу для 62,5% спрят. слов
        case 7.5:
            reloadTable(array: &dataArrayForStep[6], numberCount: hideWordsNumber) //---Перезагружаем таблицу для 75% спрят. слов
        case 8.75:
            reloadTable(array: &dataArrayForStep[7], numberCount: hideWordsNumber) //---Перезагружаем таблицу для 87,5% спрят. слов
        case 10:
            //---Цикл: прячем все слова в оригинале
            for row in 0..<arrayChar.count {
                var newRow = ""
                for word in 0..<arrayChar[row].count {
                    if arrayChar[row][word].isWord {
                        var newWord = ""
                        for _ in 0..<arrayChar[row][word].characters.count {
                            newWord += "\u{25AF}"
                        }
                        newRow += newWord + " "
                    } else {
                        newRow += arrayChar[row][word] + " "
                    }
                }
                newRow.remove(at: newRow.index(before: newRow.endIndex))
                dataArrayForStep[8][row] = newRow
            }
            //---
            //---Условие: проверяем что показываем *****/П****
            if segment.selectedSegmentIndex == 0 {
                currentDisplay = dataArrayForStep[8]
            } else if segment.selectedSegmentIndex == 1 {
                transformationWithOneLetter(currentArray: dataArrayForStep[8])
            }
        //---
        default:
            break
        }
        table.reloadData()
    }
    
    @IBAction func eye(_ sender: UIButton) {
        currentDisplay = dataArrayForStep[9]
        table.reloadData()
    }
    
    @IBAction func wwww(_ sender: UIButton) {
        dataArrayForStep[9] = currentDisplay
        currentDisplay = dataArrayForStep[0]
        table.reloadData()
    }
    
    @IBAction func segmentTap(_ sender: UISegmentedControl) {
        var tempArray = [""]
        switch stepper.value {
        case 0.0:
            tempArray = dataArrayForStep[0]
        case 1.25:
            tempArray = dataArrayForStep[1]
        case 2.5:
            tempArray = dataArrayForStep[2]
        case 3.75:
            tempArray = dataArrayForStep[3]
        case 5.0:
            tempArray = dataArrayForStep[4]
        case 6.25:
            tempArray = dataArrayForStep[5]
        case 7.5:
            tempArray = dataArrayForStep[6]
        case 8.75:
            tempArray = dataArrayForStep[7]
        //print(arrayEEE[7])
        case 10.0:
            tempArray = dataArrayForStep[8]
        default:
            break
        }
        if sender.selectedSegmentIndex == 0 {
            currentDisplay = tempArray
        } else if sender.selectedSegmentIndex == 1 {
            transformationWithOneLetter(currentArray: tempArray)
        }
        table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //--Анализируем данный стих
        for i in poem {
            arrayChar.append(i.components(separatedBy: " ")) //---Заполняем массив, состоящий из частей каждой строки стиха
        }
        //---
        dataArrayForStep = Array(repeating: Array(repeatElement("", count: poem.count)), count: 10) //---Заполняем массив пустыми значениями
        dataArrayForStep[0] = poem //---В 0 индекс добавляем оригинал стиха
        currentDisplay = poem //---В текущий экран вставляем оригинал стиха
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentDisplay[indexPath.row]
        
        //cell.textLabel?.adjustsFontSizeToFitWidth = true
        //cell.textLabel?.minimumScaleFactor = 0.5
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        //cell.textLabel?.textAlignment = .natural
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !flag && (currentDisplay[indexPath.row] != poem[indexPath.row]) {
            flag = true
            strForSelect = currentDisplay[indexPath.row]
            currentDisplay[indexPath.row] = poem[indexPath.row]
            table.reloadData()
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.flag = false
                self.currentDisplay[indexPath.row] = self.strForSelect
                self.table.reloadData()
            }
        }
    }
}

extension String {
    //---Расширение для выделения слов из строки стиха
    var words: [String] {
        var words: [String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) { word,_,_,_ in
            guard let word = word else { return }
            words.append(word)
        }
        return words
    }
    //---
    //---Расширение для определения слово/не слово
    var isWord: Bool {
        var str = ""
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) { word,_,_,_ in
            guard let word = word else { return }
            str = word
        }
        return !str.isEmpty
    }
    //---
}
