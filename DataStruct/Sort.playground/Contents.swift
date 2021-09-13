import Foundation

/// 排序类型
enum SortType: String, CaseIterable {
	case bubble = "冒泡排序"
	case select = "选择排序"
	case insert = "插入排序"
	case shell = "希尔排序"
	case heap = "堆排序"
	case merge = "并归排序"
	case quick = "快速排序"
	case radix = "基数排序"
}

extension SortType {

	func create() -> SortProtocol {
		switch self {
			case .bubble:
				return BubbleSort()
			case .select:
				return SelectSort()
			case .insert:
				return InsertSort()
			case .shell:
				return ShellSort()
			case .heap:
				return HeapSort()
			case .merge:
				return MergeSort()
			case .quick:
				return QuickSort()
			case .radix:
				return RadixSort()
		}
	}
}

/// SortProtocol
protocol SortProtocol {
	func sort(items: [Int]) -> [Int]
}

/// 冒泡排序——O(n^2)
final class BubbleSort: SortProtocol {

	func sort(items: [Int]) -> [Int] {
		var list = items
		for i in 0..<list.count {
//			print("第 \(i) 轮")
			var j = list.count - 1
			while j > i {
				if list[j - 1] > list[j] {
					(list[j - 1], list[j]) = (list[j], list[j - 1])
				}
				j -= 1
			}
		}
		return list
	}
}

/// 简单选择排序——O(n^2)
final class SelectSort: SortProtocol {
	func sort(items: [Int]) -> [Int] {
		var list = items
		for i in 0..<list.count {
			var j = i + 1
			var minValue = list[i]
			var minIndex = i
			while j < list.count {
				if minValue > list[j] {
					minValue = list[j]
					minIndex = j
				}
				j += 1
			}
			if minIndex != i {
				(list[i], list[minIndex]) = (list[minIndex], list[i])
			}
		}
		return list
	}
}

/// 插入排序——O(n^2)
final class InsertSort: SortProtocol {
	func sort(items: [Int]) -> [Int] {
		var list = items
		for i in 1..<list.count {
			var j = i
			while j > 0 {
				if list[j] < list[j - 1] {
					(list[j - 1], list[j]) = (list[j], list[j - 1])
					j -= 1
				} else {
					break
				}
			}
		}
		return list
	}
}

/// 希尔排序——O(n^(3/2))
final class ShellSort: SortProtocol {
	func sort(items: [Int]) -> [Int] {
		var list = items
		var step: Int = list.count / 2
		while step > 0 {
			for i in 0..<list.count {
				var j = i + step
				while j >= step && j < list.count {
					if list[j] < list[j - step] {
						(list[j - step], list[j]) = (list[j], list[j - step])
						j -= step
					} else {
						break
					}
				}
			}
			step = step / 2
		}
		return list
	}
}

/// 堆排序 (O(nlogn))
final class HeapSort: SortProtocol {
	func sort(items: [Int]) -> [Int] {
		var list = items
		var endIndex = items.count - 1
		heapCreate(&list)
		while endIndex >= 0 {
			/// 将大顶堆的顶点（最大的那个值）与大顶堆的最后一个值进行交换
			(list[0], list[endIndex]) = (list[endIndex], list[0])
			/// 缩减大顶堆范围
			endIndex -= 1
			/// 对交换后的大顶堆进行调整，使其重新成为大顶堆
			heapAdjast(&list, startIndex: 0, endIndex: endIndex + 1)
		}
		return list
	}
	
	/// 构建大顶堆的层次遍历序列（f(i) > f(2i), f(i) > f(2i+1) i > 0
	/// - Parameter items: 构建大顶堆的序列
	private func heapCreate(_ items: inout [Int]) {
		var i = items.count
		while i > 0 {
			heapAdjast(&items, startIndex: i - 1, endIndex: items.count)
			i -= 1
		}
	}

	/// 对大顶堆的局部进行调整，使其该节点的所有父类符合大顶堆的特点
	/// - Parameters:
	///   - items: list
	///   - startIndex: 当前要调整的节点
	///   - endIndex: 当前要调整的节点
	private func heapAdjast(_ items: inout [Int], startIndex: Int, endIndex: Int) {
		/// 根节点
		let temp = items[startIndex]
		/// 父节点
		var fatherIndex = startIndex + 1
		/// 左子节点
		var maxChildIndex = 2 * fatherIndex
		while maxChildIndex <= endIndex {
			/// 比较左右子节点，并找出比较大的下标
			if maxChildIndex < endIndex && items[maxChildIndex - 1] < items[maxChildIndex] {
				maxChildIndex += 1
			}
			/// 如果较大的那个子节点比根节点大，就将该节点的值赋给父节点
			if temp < items[maxChildIndex - 1] {
				items[fatherIndex - 1] = items[maxChildIndex - 1]
			} else {
				break
			}
			fatherIndex = maxChildIndex
			maxChildIndex = 2 * fatherIndex
			items[fatherIndex - 1] = temp
		}
	}
}

/// 归并排序O(nlogn)
final class MergeSort: SortProtocol {
	func sort(items: [Int]) -> [Int] {
		if items.isEmpty { return items }
		var mergeItems = items.map { [$0] }
		while mergeItems.count != 1 {
			var i = 0
			while i < mergeItems.count - 1 {
				mergeItems[i] = merge(firstList: mergeItems[i], secondList: mergeItems[i + 1])
				mergeItems.remove(at: i + 1)
				i += 1
			}
		}
		return mergeItems[0]
	}

	private func merge(firstList: [Int], secondList: [Int]) -> [Int] {
		var resultItems: [Int] = []
		var firstIndex: Int = 0
		var secondIndex: Int = 0
		while firstIndex < firstList.count && secondIndex < secondList.count {
			if firstList[firstIndex] < secondList[secondIndex] {
				resultItems.append(firstList[firstIndex])
				firstIndex += 1
			} else {
				resultItems.append(secondList[secondIndex])
				secondIndex += 1
			}
		}
		while firstIndex < firstList.count {
			resultItems.append(firstList[firstIndex])
			firstIndex += 1
		}
		while secondIndex < secondList.count {
			resultItems.append(secondList[secondIndex])
			secondIndex += 1
		}
		return resultItems
	}
}

/// 快速排序O(nlogn)
final class QuickSort: SortProtocol {
	func sort(items: [Int]) -> [Int] {
		var list = items
		quick(&list, low: 0, high: list.count - 1)
		return list
	}

	/// 快速排序
	/// - Parameters:
	///   - list: 排序数组
	///   - low: 数组下界
	///   - high: 数组上界
	private func quick(_ list: inout [Int], low: Int, high: Int) {
		if low < high {
			let mid = partition(&list, low: low, high: high)
			quick(&list, low: low, high: mid - 1)
			quick(&list, low: mid + 1, high: high)
		}
	}

	/// 将数组以第一个值为准分成两部分，前半部分比该值要小，后半部分比该值要大
	/// - Parameters:
	///   - list: 要二分的数组
	///   - low: 数组下界
	///   - high: 数组上界
	/// - Returns: 分界点
	private func partition(_ list: inout [Int], low: Int, high: Int) -> Int {
		var low = low
		var high = high
		let temp = list[low]
		while low < high {
			while low < high && list[high] >= temp {
				high -= 1
			}
			list[low] = list[high]
			while low < high && list[low] <= temp {
				low += 1
			}
			list[high] = list[low]
		}
		list[low] = temp
		return low
	}
}

/// 基数排序
final class RadixSort: SortProtocol {
	func sort(items: [Int]) -> [Int] {
		var list = items
		if !list.isEmpty {
			radix(&list)
		}
		return list
	}

	private func radix(_ list: inout [Int]) {
		var bucket = createBucket()
		let maxNumber = maxItem(list)
		let maxLength = numberLength(maxNumber)
		for digit in 1...maxLength {
			/// 入桶
			for item in list {
				let baseNumber = fetchBase(number: item, digit: digit)
				/// 根据基数入桶
				bucket[baseNumber].append(item)
			}
			/// 出桶
			var index: Int = 0
			for i in 0..<bucket.count {
				while !bucket[i].isEmpty {
					list[index] = bucket[i].remove(at: 0)
					index += 1
				}
			}
		}
	}

	/// 创建10个桶
	/// - Returns: 返回创建好的桶
	private func createBucket() -> [[Int]] {
		return (0..<10).map { _ in [] }
	}

	/// 计算序列中最大的那个数
	/// - Parameter list: 数列
	/// - Returns: 返回该数列中最大的值
	private func maxItem(_ list: [Int]) -> Int {
		var maxItem = list[0]
		for item in list {
			if maxItem < item {
				maxItem = item
			}
		}
		return maxItem
	}

	/// 获取数字的长度
	/// - Parameter number: 该数字
	/// - Returns: 返回该数字的长度
	private func numberLength(_ number: Int) -> Int {
		return "\(number)".count
	}

	/// 获取相应位置的数字
	/// - Parameters:
	///   - number: 操作的数字
	///   - digit: 位数
	/// - Returns: 返回该位数上的数字
	private func fetchBase(number: Int, digit: Int) -> Int{
		if digit > 0 && digit <= numberLength(number) {
			var numbersArray: Array<Int> = []
			for char in "\(number)" {
				numbersArray.append(Int("\(char)")!)
			}
			return numbersArray[numbersArray.count - digit]
		}
		return 0
	}
}

let items = Array(0..<1000).shuffled()

SortType.allCases.forEach {
	let sort = $0.create()
	print("\($0.rawValue) 开始 \(Date())")
//	print("原始列表: \(items.description)")
	let time = CFAbsoluteTimeGetCurrent()
	let sortItem = sort.sort(items: items)
	let useTime = CFAbsoluteTimeGetCurrent() - time
//	print("排序列表: \(sortItem.description)")
	print("\($0.rawValue) 结束 耗时:\(useTime)s")
}
