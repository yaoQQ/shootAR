
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;


public class EnemyGun:GunBase,IEnemyGun
{
    //回收
    private List<Bullet> bulletList = new List<Bullet>();
    private GameObject cloneBullet;
    //设置玩家射击按钮，标志位

    public override void Update()
    {
        base.Update();
        if (isCanShoot)
            return;
        time += Time.deltaTime;
        if (time >= coolTime)
        {
            isCanShoot = true;
            time = 0;
        }
    }
    //从缓存的无用子弹中获取子弹
    private Bullet getBullet()
    {
        for (int i = 0; i < bulletList.Count; i++)
        {
            if (bulletList[i].gameObject.activeSelf == false)
            {
                bulletList[i].ReAcvtive();
                return bulletList[i];
            }
        }
        Bullet obj = createBullet();
        return obj;
    }

    public override void Shoot()
    {
        Vector3 pos = CameraManager.Instance.Player.position;
        this.transform.LookAt(pos);
        base.Shoot();
        if (isCanShoot)
        {
            if (cloneBullet != null && !cloneBullet.name.Equals(bulletName))//换了子弹类型
            {
                cloneBullet = null;
            }
            isCanShoot = false;
            Bullet obj = getBullet();
            if (obj == null)
                return;
            obj.transform.position = this.transform.position;
            obj.transform.forward = this.transform.forward;
        }
    }
    //创建子弹
    private Bullet createBullet()
    {

        cloneBullet = MyUtils.LoadBulletPrefab(bulletName);
        cloneBullet.name = bulletName;

        Bullet obj = cloneBullet.GetComponent<Bullet>();
        bulletList.Add(obj);
        //判断是哪方的子弹
        obj.shootTag = MyUtils.getEnemyTagByCamp(camp);
        return obj;
    }
    public override void Dead()
    {
       
    }
    public override void OnDestroy()
    {
        base.OnDestroy();
        for (int i = 0; i < bulletList.Count; i++)
        {
            if (bulletList[i] == null)
                continue;
            GameObject.Destroy(bulletList[i].gameObject);
        }
    }
}

