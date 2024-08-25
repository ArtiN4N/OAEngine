package OAEngine

find_min :: proc(array: $A/[]$T) -> int {
    if len(array) == 0 {
        return 0
    }

    min := array[0]

    for ele in array {
        if ele < min {
            min = ele
        }
    }

    return int(min)
}