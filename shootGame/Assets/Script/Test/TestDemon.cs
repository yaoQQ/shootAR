using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class TestDemon : MonoBehaviour
{

    // Use this for initialization
    public int sceneCount = 5;
    private int level = 0;

    public void Awake()
    {

        GameObject.DontDestroyOnLoad(this.gameObject);
    }

    void Start()
    {
        //GameObject.DontDestroyOnLoad(this.gameObject);
    }

    // Update is called once per frame
    void Update()
    {
        Debug.Log(this.gameObject.name + "this.transform.position=" + this.transform.position);
    }
    void OnGUI()
    {
        if (GUI.Button(new Rect(0, 0, 40, 40), "test"))
        {
            level++;


            if (level > sceneCount)
            {
                level = 0;
                GameObject.Destroy(this.gameObject);
            }
            SceneManager.LoadScene(level);
        }

    }

}
