using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


public class ShipMoveCircleAttrack2 : Enemy
{
    public enum fly_state
    {
        fly_begin,
        targetPlayer,
        fly,
        turn_begin,
        turn
    }
    public GunBase gun;
    public float attachDistance = 2;//攻击距离

    public fly_state _currState = fly_state.fly_begin;
    public override void Awake()
    {
        base.Awake();
        shipType = EnemyShipType.FarAttack;
        gun = this.gameObject.GetComponentInChildren<GunBase>();
    }

    //对象池重新获取调用
    public override void Active()
    {
        base.Active();
        fly_begin();
    }
    public override void Start()
    {
        base.Start();
        targetPos = CameraManager.Instance.Player.position + CameraManager.Instance.Player.forward;
        LookAtPos(targetPos);
    }
    public override void lookTargetRotate()
    {
        if (isReadRote)
        {
            return;
        }
        Quaternion newRotation = Quaternion.Lerp(transform.rotation, targetRotation, 4 * Time.deltaTime);
        transform.rotation = newRotation;
    }
    protected override void MoveToPos(Vector3 pos)
    {

        UpdateState(_currState);
        //与玩家保持距离攻击
        if (Vector3.Distance(this.transform.position, CameraManager.Instance.Player.position) <= attachDistance)
        {
            attackPlayer();
        }
        lookTargetRotate();
        if (Vector3.Distance(gameObject.transform.position, targetPos) < speed)
        {
            // Debug.Log(gameObject.name + "ArrivePos");
            ArrivePos(targetPos);

        }
        //if (_currState == fly_state.fly || isReadRote)
        //{
        gameObject.transform.position = Vector3.MoveTowards(gameObject.transform.position, targetPos, speed * Time.deltaTime);
        //   }
        LookAtPos(pos);
    }
    void OnDrawGizmos()//画线 
    {
        Gizmos.color = Color.yellow;
        for (int i = 0; i < pathList.Count - 1; i++)
        {
            Gizmos.DrawLine(pathList[i], pathList[i + 1]);
            Gizmos.DrawSphere(pathList[i], 0.2f);

        }

        Color[] colorList = new Color[5
            ] { Color.black, Color.blue, Color.green, Color.red, Color.red };
        if (_pathLocations == null)
        {
            return;
        }
        for (int i = 0; i < _pathLocations.Count; i++)
        {
            Gizmos.color = colorList[i];
            //			Gizmos.DrawSphere (roundPoint[i], 0.5f);
        }

    }
    //到达目标点 追逐玩家
    protected override void ArrivePos(Vector3 pos)
    {
        base.ArrivePos(pos);
        LookAtPos(targetPos);
    }

    //攻击玩家 条件和行为
    protected override void attackPlayer()
    {
        base.attackPlayer();
        if (shipType == EnemyShipType.FarAttack)
        {

            float angel = MyUtils.Angle(CameraManager.Instance.MainCamera.transform.position, this.transform.position, this.transform.forward);
            if (angel < 150)//对着才射击
            {
                return;
            }
            if (gun != null)
            {
                gun.transform.LookAt(CameraManager.Instance.Player.position);
                LookAtPos(targetPos);
                gun.Shoot();
            }
        }
    }


    private List<Vector3> _pathLocations = null;
    private void UpdateState(fly_state currState)
    {
        switch (currState)
        {
            case fly_state.fly_begin:
                fly_begin();//生成到玩家位置前路径
                _currState = fly_state.targetPlayer;
                break;
            case fly_state.targetPlayer:
                if (pathList.Count == 0)
                {
                    CirclePlayer();//到达玩家位置前，生成环绕玩家路径
                    _currState = fly_state.fly;
                }
                break;
            case fly_state.fly:
                if (pathList.Count == 0)
                {
                    turnBegain();//生成转弯到玩家方向路径
                    _currState = fly_state.turn;

                }
                break;
            //case fly_state.turn_begin:
            //    turnBegain();//生成转弯到玩家方向路径
            //    _currState = fly_state.turn;
            //    break;
            case fly_state.turn://旋转中
                if (pathList.Count == 0)
                {
                    _currState = fly_state.fly_begin;//旋转完
                }
                break;
        }
    }


    private void fly_begin()
    {
        float attackRange = 0.2f;
        Vector3 targetPos = CameraManager.Instance.Player.localPosition;
        Vector3 targetForwardVector = CameraManager.Instance.Player.forward;
        Vector3 targetRightVector = CameraManager.Instance.Player.right;
        Vector3 selfPos = this.transform.localPosition;
        Vector3 vectorFromSelfToTarget = (targetPos - selfPos).normalized;
        float dis = Vector3.Distance(selfPos, targetPos);
        _pathLocations = new List<Vector3>();
        //起点
        Vector3 pos1 = selfPos + this.transform.forward / 2;
        //与目标相隔一个攻击范围的点
        Vector3 pos2 = pos1 + this.transform.right * attackRange * 2; ;

        Vector3 pos3 = pos2 + vectorFromSelfToTarget * attackRange * 3; ;
        //随机往左还是右偏移
        Vector3 flyPos3OffsetRight = targetRightVector;
        int flyPos3ValueRandom = UnityEngine.Random.Range(0, 10);
        if (flyPos3ValueRandom > 5)
            flyPos3OffsetRight = -targetRightVector;
        Vector3 pos4 = targetPos + flyPos3OffsetRight * attackRange - vectorFromSelfToTarget * attackRange * 1;
        float pos3OffsetY = UnityEngine.Random.Range(0, attackRange * 0.5f);
        pos3.y += pos3OffsetY;

        Vector3 pos5 = pos4 + vectorFromSelfToTarget * attackRange * 2;
        _pathLocations.Add(pos1);
        _pathLocations.Add(pos2);
        _pathLocations.Add(pos3);
        _pathLocations.Add(pos4);
        _pathLocations.Add(pos5);
        CurveMaker flyCurve = new CurveMaker(_pathLocations, 5);
        pathList = flyCurve.GetPointList();
    }
    //到达玩家点 ，生成运行轨迹
    private void CirclePlayer()
    {
        Vector3 targetPos = CameraManager.Instance.Player.localPosition;
        Vector3 targetForwardVector = CameraManager.Instance.Player.forward;
        Vector3 targetRightVector = CameraManager.Instance.Player.right;
        Vector3 selfPos = this.transform.localPosition;
        Vector3 vectorFromSelfToTarget = targetPos - selfPos;
        vectorFromSelfToTarget = vectorFromSelfToTarget.normalized;
        float dis = Vector3.Distance(selfPos, targetPos);

        _pathLocations = new List<Vector3>();

        ////起点
        Vector3 pos1 = selfPos + this.transform.forward / 2;

        //与目标相隔一个攻击范围的点
        //   Vector3 pos2 = pos1 + vectorFromSelfToTarget * (dis - attachDistance);
        Vector3 pos2 = pos1 + vectorFromSelfToTarget * attachDistance;
        //随机往左还是右偏移
        Vector3 flyPos3OffsetRight = UnityEngine.Random.Range(0, 10) > 5 ? -targetRightVector : targetRightVector;
        Vector3 pos3 = targetPos + flyPos3OffsetRight * attachDistance * 0.5f;
        float pos3OffsetY = UnityEngine.Random.Range(0, attachDistance * 0.5f);
        pos3.y += pos3OffsetY;

        Vector3 pos4 = targetPos + vectorFromSelfToTarget * (dis + attachDistance * 1.2f);

        _pathLocations.Add(pos1);
        _pathLocations.Add(pos2);
        _pathLocations.Add(pos3);
        _pathLocations.Add(pos4);

        CurveMaker flyCurve = new CurveMaker(_pathLocations, 20);
        pathList = flyCurve.GetPointList();

    }
    private void turnBegain()
    {
        float attackRange = 0.2f;
        _pathLocations = new List<Vector3>();
        Vector3 targetPos = CameraManager.Instance.Player.localPosition;
        Vector3 targetForwardVector = CameraManager.Instance.Player.forward;
        Vector3 targetRightVector = CameraManager.Instance.Player.right;
        Vector3 selfPos = this.transform.localPosition;
        Vector3 vectorFromSelfToTarget = targetPos - selfPos;
        vectorFromSelfToTarget = vectorFromSelfToTarget.normalized;
        //出发点
        Vector3 pos1 = selfPos + this.transform.forward / 2;
        Vector3 turnPos3OffsetRight = targetRightVector;
        Vector3 objRight = this.transform.right;
        int turnPos3ValueRandom = UnityEngine.Random.Range(0, 10);
        if (turnPos3ValueRandom > 5)
            turnPos3OffsetRight = -targetRightVector;

        Vector3 pos2 = pos1 + objRight * attackRange * 5;
        Vector3 pos3 = pos2 + vectorFromSelfToTarget * attackRange * 8;
        Vector3 pos4 = pos3 + turnPos3OffsetRight * attackRange * 10f;
        Vector3 pos5 = pos4 + vectorFromSelfToTarget * attackRange * 15;
        _pathLocations.Add(pos1);
        _pathLocations.Add(pos2);
        _pathLocations.Add(pos3);
        _pathLocations.Add(pos4);
        _pathLocations.Add(pos5);

        CurveMaker turnCurve = new CurveMaker(_pathLocations, 15);
        pathList = turnCurve.GetPointList();
    }
}



