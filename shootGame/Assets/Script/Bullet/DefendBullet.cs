using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class DefendBullet : ShipBase
{
    public float liveTime = 20f;//存在时间

    public void Start()
    {

    }

    public void Update()
    {
        liveTime -= Time.deltaTime;
        if (liveTime <= 0)
        {
            Dead();
        }
    }
}

