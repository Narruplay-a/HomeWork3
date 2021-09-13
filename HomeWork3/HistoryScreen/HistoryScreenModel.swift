//
//  HistoryScreenModel.swift
//  HomeWork3
//
//  Created by Adel Khaziakhmetov on 06.09.2021.
//

import SwiftUI
import Combine

final class HistoryScreenModel: ObservableObject {
    @Published
    var historyData     : [HistoryData]     = .init()
    var service         : JobScheduler<MeasureJob>       = .init()
    var cancellable     : AnyCancellable?
    
    var minimalIndex    : Int               = 0
    var maximumIndex    : Int               = 0
    
    func loadHistoryData() {
        guard let data = UserDefaults.standard.stringArray(forKey: "history_data") else {
            historyData = []
            return
        }
        
        guard historyData.count != data.count else { return }
        
        historyData = []
        for item in data {
            historyData.append(HistoryData(title: item))
        }
    }
    
    func createOrAppendHistoryData() {
        guard historyData.count == 0 else { return }
        
        appendHistoryData()
        
        var historyArray: [String] = .init()
        historyArray = historyData.map { $0.title }
        UserDefaults.standard.set(historyArray, forKey: "history_data")
    }

    func runTest() {
        guard historyData.count > 0 else { return }
        
        for item in historyData {
            service.add(task: MeasureJob({
                var array = SuffixArray(dataSource: item.title)
                array.getSuffixes()
            }))
        }
        
        service.start()
        
        cancellable = service.completeSubject.sink(receiveValue: { [weak self] tasks in
            guard let self = self else { return }

            var minimalTime     : TimeInterval      = 0
            var maximumTime     : TimeInterval      = 0
            
            for i in 0..<tasks.count {
                let measureTime = tasks[i].measureTime!
                if measureTime < minimalTime || minimalTime == 0 {
                    minimalTime = measureTime
                    self.minimalIndex = i
                }
                
                if measureTime > maximumTime {
                    maximumTime = measureTime
                    self.maximumIndex = i
                }
                
                self.historyData[i].time = measureTime
                self.historyData[i].index = i
            }
        })
    }
}

private extension HistoryScreenModel {
    func appendHistoryData() {
        historyData.append(HistoryData(title: firstString))
        historyData.append(HistoryData(title: secondString))
        historyData.append(HistoryData(title: thirdString))
    }
}

let firstString = """
    Реализация асинхронного выполнения задач и оценка эффективности подхода
    Цель:
    Научиться внедрять сервис очереди в существующую инфраструктуру приложение, развиваем навык рефакторинга для не-UI кода приложения
    Сделать таб историю шарингов на основе предыдущего таьа
    Реализовать структуру данных Job Queue
    Создать сервис Job Scheduler
    В хедере таблицы экрана Feed сделать возможность запускать один конкретный тест по всем айтемам истории на построение суффиксного массива
    В ячейку выводить время построение
    *6. Красить в зеленый лучшее время и в красный худшее, или градацие от зеленого к красному
    Критерии оценки:
    Факт сдачи дз - 40 баллов Сдача во время - 10 баллов Работающий Job Scheduler - 20 баллов Возможность запустить один тест на нескольких структурах данных - 20 баллов Вывод в ячейку - 10 баллов
    Реализовать структуру данных Job Queue
    Создать сервис Job Scheduler
    В хедере таблицы экрана Feed сделать возможность запускать один конкретный тест по всем айтемам истории на построение суффиксного массива
    В ячейку выводить время построение
    *6. Красить в зеленый лучшее время и в красный худшее, или градацие от зеленого к красному
    Критерии оценки:
    Факт сдачи дз - 40 баллов Сдача во время - 10 баллов Работающий Job Scheduler - 20 баллов Возможность запустить один тест на нескольких структурах данных - 20 баллов Вывод в ячейку - 10 баллов
    Реализовать структуру данных Job Queue
    Создать сервис Job Scheduler
    В хедере таблицы экрана Feed сделать возможность запускать один конкретный тест по всем айтемам истории на построение суффиксного массива
    В ячейку выводить время построение
    *6. Красить в зеленый лучшее время и в красный худшее, или градацие от зеленого к красному
    Критерии оценки:
    Факт сдачи дз - 40 баллов Сдача во время - 10 баллов Работающий Job Scheduler - 20 баллов Возможность запустить один тест на нескольких структурах данных - 20 баллов Вывод в ячейку - 10 баллов
    """

let secondString = """
    Данное сообщение (материал) создано и (или) распространено иностранным средством массовой информации, выполняющим функции иностранного агента, и (или) российским юридическим лицом, выполняющим функции иностранного агента.
    """

let thirdString = """
    Россиянин Даниил Медведев стал победителем Открытого чемпионата США по теннису.
    В финальном матче турнира, проходившего в Нью-Йорке, он обыграл первую ракетку мира серба Новака Джоковича в трех сетах со счетом 6:4, 6:4, 6:4.
    Для 25-летнего россиянина это первая победа на турнирах «Большого шлема». Сейчас в рейтинге Ассоциации теннисистов-профессионалов (ATP) он занимает второе место.
    Медведев стал третьим в истории россиянином, выигравшим мужской турнир «Большого шлема».
    """
