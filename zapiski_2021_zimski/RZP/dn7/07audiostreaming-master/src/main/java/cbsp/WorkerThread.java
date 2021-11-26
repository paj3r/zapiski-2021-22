package cbsp;

import java.io.IOException;

public class WorkerThread extends Thread {
    
    Callable t;
    
    public WorkerThread(Callable t) {
        this.t=t;
    }
    
    @Override
    public void run() {
        try {
            t.callback();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
