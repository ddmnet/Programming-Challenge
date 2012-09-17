import scala.collection.mutable.Queue
import scala.collection.mutable.MutableList
import scala.collection.mutable.Set

object ryanc {
	def main(args: Array[String]) = {
		if (args.length == 0) {
			println("Please enter some arguments.")
			System.exit(1)
		}
		val argsList = args.toList
		val start = Integer.parseInt(argsList(0))
		val end = Integer.parseInt(argsList(1))
		val queue = Queue[(Int, Set[Int], MutableList[Int])]()
		queue += ((start, Set[Int](start), MutableList[Int](start)))
		while (!queue.isEmpty) {
			val (number, parents, tree) = queue.dequeue
			val newNumbers = MutableList[Int]( (number * 2), (number + 2) )
			if ((number % 2) == 0) {
				newNumbers += (number / 2)
			}
			
			newNumbers foreach { newNumber =>
				if (!parents.contains(newNumber)) {
					val res = tree ++  MutableList[Int](newNumber)
					parents += newNumber
					if (newNumber == end) {
						println(res mkString ",")
						System.exit(1)
					}
					queue += ((newNumber, parents, res))
				}
			}
		}
	}
}
