using namespace System.Collections.Generic

class DelayedFlag {
    [Queue[bool]] $FlagQueue

    DelayedFlag([int] $depth, [bool] $initValue) {
        $this.FlagQueue = [Queue[bool]]::new($depth)
        for ($i = 0; $i -lt $depth; $i++) {
            $this.FlagQueue.Enqueue($initValue)
        }
    }

    [void] Set([bool] $value) {
        $this.FlagQueue.Dequeue()
        $this.FlagQueue.Enqueue($value)
    }

    [bool] Get() {
        return $this.FlagQueue.Peek()
    }
}
