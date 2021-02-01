#lang racket
(require net/url
         html-parsing
         sxml/sxpath)

(define weather "http://www.data.jma.go.jp/stats/etrn/view/daily_a1.php?prec_no=33&block_no=1120&year=2020&month=12&day=&view=a2")

(define (page-get url)
  (call/input-url (string->url url)
                  get-pure-port
                  html->xexp))

(define (take-nths n column-count xs)
  (define (iter acc ys)
    (if (> n (- (length ys) 1))
        acc
        (iter (cons (list-ref ys n) acc) (drop ys column-count))))
  (iter '() xs))

(reverse
 (take-nths
  5
  10
  (map caddr
       ((sxpath "//td[@class = 'data_0_0']")
        (page-get weather)))))
