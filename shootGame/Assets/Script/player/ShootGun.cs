
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


public class ShootGun : MonoBehaviour
{
    public string bulletName;

    public const float coolTime = 0.3f;

    private float time = 0;
    private bool isCanShoot = true;
    private GameObject bullet;

    private List<GameObject> bulletList =new List<GameObject>();
    void Awake()
    {

    }
    void Start()
    {

    }
    void Update()
    {
        if (isCanShoot)
            return;
        time += Time.deltaTime;
        if(time>= coolTime)
        {
            isCanShoot = true;
            time = 0;
        }
    }
    
    
}

