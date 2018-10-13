you need to have 2 things installed

pafy (pip install pafy)
youtube_dl (sudo pip install --upgrade youtube_dl)
after installing these two packages you can use the youtube url to play the streaming videos from you tube. Please refer the code below
   
   
   url = 'https://youtu.be/W1yKqFZ34y4'
    vPafy = pafy.new(url)
    play = vPafy.getbest(preftype="webm")

    #start the video
    cap = cv2.VideoCapture(play.url)
    while (True):
        ret,frame = cap.read()
        """
        your code....
        """
        cv2.imshow('frame',frame)
        if cv2.waitKey(20) & 0xFF == ord('q'):
            break    

    cap.release()
    cv2.destroyAllWindows()