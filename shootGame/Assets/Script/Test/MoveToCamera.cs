using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveToCamera : MonoBehaviour
{

    // Use this for initialization
    private Camera _cameara;
    private Vector3 targetVec;
    private float speed = 200f;
    public float life = 100;

    private 
    void Start()
    {
        _cameara = CameraManager.Instance.MainCamera;

    }

    // Update is called once per frame
    void Update()
    {
        this.transform.position += this.transform.forward * speed * Time.deltaTime;
      //  float distance = Vector3.Distance(this.transform.position, _cameara.transform.position);
        if (this.transform.position.z > 1800|| this.transform.position.z < -1800)
        {
            Debug.Log("monster distance > 1800|| distance<-1800 destory!!!");
            MonsterManager.Instance.destoy(this.gameObject);
        }
    }

    void OnGUI()
    {
        if (GUI.Button(new Rect(0, 0, 100, 50), "test"))
        {

        }
    }

    private void move(Vector3 targetPos)
    {
        transform.LookAt(_cameara.transform.position);
        targetVec = _cameara.transform.position;
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.transform.tag == Tags.mainCamera)
        {
            CameraManager.Instance.Damage();
            Debug.Log("destory monster  ther.transform.tag == Tags.mainCamera ");
            MonsterManager.Instance.destoy(this.gameObject);
            
        }else if(other.transform.tag == Tags.Bullet)
        {
            Debug.Log("destory monster  ther.transform.tag == Tags.Bullet ");
            MonsterManager.Instance.destoy(this.gameObject);
            GameObject.Destroy(other.gameObject);
        }

    }
}
