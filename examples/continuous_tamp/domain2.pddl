(define (domain continuous-tamp)
  (:requirements :strips :equality)
  (:predicates
    ; Static predicates
    (Block ?b)
    (Region ?r)
    (Pose ?b ?p)
    (Conf ?q)
    (Traj ?t)
    (Contained ?b ?p ?r)
    (Kin ?b ?q ?p)
    (Motion ?q1 ?t ?q2)
    (CFree ?b1 ?p1 ?b2 ?p2)
    (Placeable ?b ?r)
    (PoseCollision ?b1 ?p1 ?b2 ?p2)
    (TrajCollision ?t ?b2 ?p2)

    ; Fluent predicates
    (AtPose ?b ?p)
    (AtConf ?q)
    (Holding ?b)
    (HandEmpty)
    (CanMove)

    ; Derived predicates
    (In ?b ?r)
    (UnsafePose ?b ?p)
    (UnsafeTraj ?t)
    (Reachable ?q1 ?q2)
    (SafePose ?b ?p)
  )
  (:functions
    (Distance ?q1 ?q2)
  )
  (:action move
    :parameters (?q1 ?t ?q2)
    :precondition (and (Motion ?q1 ?t ?q2)
                       (AtConf ?q1) (CanMove) (not (UnsafeTraj ?t)))
    :effect (and (AtConf ?q2)
                 (not (AtConf ?q1)) (not (CanMove))
                 (increase (total-cost) (Distance ?q1 ?q2))))
  (:action pick
    :parameters (?b ?p ?q)
    :precondition (and (Kin ?b ?q ?p)
                       (AtConf ?q) (AtPose ?b ?p) (HandEmpty))
    :effect (and (Holding ?b) (CanMove)
                 (not (AtPose ?b ?p)) (not (HandEmpty))
                 (increase (total-cost) 10))
  )
  (:action place
    :parameters (?b ?p ?q)
    :precondition (and (Kin ?b ?q ?p)
                       (AtConf ?q) (Holding ?b)) ; (SafePose ?b ?p))
    :effect (and (AtPose ?b ?p) (HandEmpty) (CanMove)
                 (not (Holding ?b))
                 (increase (total-cost) 10))
  )
  ;(:derived (SafePose ?b1 ?p1)
  ;  (and (Pose ?b1 ?p1)
  ;      (forall (?b2) (imply (Block ?b2) (or
  ;          (Holding ?b2) ; not equal
  ;          (exists (?p2) (and (CFree ?b1 ?p1 ?b2 ?p2)
  ;                             (AtPose ?b2 ?p2))))
  ;      ))))

  (:derived (In ?b ?r)
    (exists (?p) (and (Contained ?b ?p ?r)
                      (AtPose ?b ?p))))
)